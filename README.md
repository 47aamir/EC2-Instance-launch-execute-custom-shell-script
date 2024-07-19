# EC2 Instance Management Script

This repository contains a Bash script (`ec2_create.sh`) for creating and managing multiple EC2 instances on AWS. The script launches a specified number of EC2 instances, waits for them to be in a running state, and then executes a custom script (`script.sh`) on each instance.

## Setup Tutorial

### Prerequisites

1. **IAM User with EC2 Permissions**

   - Create an IAM user with permissions to manage EC2 instances. You can do this from the AWS Management Console.
   - Attach the following policies to the IAM user:
     - `AmazonEC2FullAccess`
     - `AmazonEC2ReadOnlyAccess`

2. **Create Access Key**

   - Generate an access key for the IAM user you created.
   - Save the Access Key ID and Secret Access Key; you will need them for configuring `awscli`.

3. **Install AWS CLI**

   You need to have AWS CLI installed to interact with AWS services. You can install it using one of the following methods:

   - Using pip:
     ```bash
     pip install awscli
     ```

   - Using apt-get (for Debian-based systems):
     ```bash
     sudo apt-get update
     sudo apt-get install awscli
     ```

4. **Configure AWS CLI**

   Configure AWS CLI with your IAM user's access key and secret key:
   ```bash
   aws configure
   ```
  Follow the prompts to enter your Access Key ID, Secret Access Key, region, and output format.

5. **Edit script.sh**

  Modify script.sh to include the commands you want to run on each EC2 instance.

6. **Set Permissions and Run the Script**

  - Make ec2_create.sh executable:
    ```bash
    chmod +x ec2_create.sh
    ```
  - Run the script:
    ```bash
    ./ec2_create.sh
    ```
  - When prompted, enter the number of EC2 instances you want to create. The script will handle the rest.

# Script Details
  - ec2_create.sh: The main script that creates EC2 instances, waits for them to be in a running state, and executes script.sh on each instance.
  - script.sh: The script to be executed on each EC2 instance. Edit this file with your desired commands.
