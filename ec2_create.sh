#!/bin/bash

while true; do
  read -p "Count of EC2-Instances, you want to create: " countec2
  if [[ "$countec2" =~ ^[0-9]+$ ]]; then
    break
  else
    echo "Please enter a valid number."
  fi
done

declare -a instance_ids
# Launch the EC2 instance and capture the instance ID
launch_ec2() {
    aws ec2 run-instances \
        --image-id ami-0aff18ec83b712f05 \
        --instance-type t2.micro \
        --key-name oregon \
        --security-group-ids sg-08e2e896170c022 \
        --subnet-id subnet-05e989dfbddccc6 \
        --count 1 \
        --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=MyInstance-'$1'}]' \
        --query 'Instances[0].InstanceId' \
        --output text
}

ssh1() {
	cat ./script.sh | ssh -i ~/Downloads/YourKey.pem -o StrictHostKeyChecking=no ubuntu@$1 'bash -s' - &
}

for ((n=1; n<=countec2; n++))
do
    instance_ids[$n]=$(launch_ec2 $n)
done
# Wait until the instance is in the running state

sleep 10
for instance_id in ${instance_ids[@]}
do
    echo "Getting Public IP of an instance..."
    sleep 5
    PUBLIC_IP=$(aws ec2 describe-instances \
    --instance-ids $instance_id \
    --query 'Reservations[0].Instances[0].PublicIpAddress' \
    --output text)
    echo '---'
    echo "[#]- $instance_id : $PUBLIC_IP"
    echo '---'
    while true; do
	    echo "Checking if instance is in running state......."
        if [[ $(aws ec2 describe-instances --instance-ids "$instance_id" --query 'Reservations[*].Instances[*].State.Name' --output text) == 'running' ]];then
		echo "Instance is ready!, now waiting for instance to accept connection on port 22"
	       while true;do
		       nc -zv "$PUBLIC_IP" 22 > /dev/null 2>&1
		       if [[ $? == 0 ]];then
			       echo "Connection established!!!!!!!!!!!!!"
				break
		       fi
		       sleep 5
	       done
	       break
        fi
        sleep 10  # Adding sleep to avoid a tight loop
    done

    echo 'Executing ./script.sh in remote server having IP' $PUBLIC_IP
    ssh1 $PUBLIC_IP > /dev/null 2>&1

    if [[ $? == 0 ]];then
	    echo "Script executed succesfully in $PUBLIC_IP"
    else
	    echo "There is an issue while executing script in $PUBLIC_IP"
    fi
done
