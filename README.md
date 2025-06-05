# Multi-Account EBS Audit

This solution provides automated auditing of EBS volumes across multiple AWS accounts (Target Accounts) and regions (Target Regions). It identifies unused EBS volumes and sends email reports to specified recipients (Single Sender, Multiple Recipients) alongwith, storing a .csv file of the report in an S3 bucket.

## Description

The **Multi-Account EBS Audit** is a solution that automates the discovery and reporting of unused EBS volumes across multiple AWS accounts and regions. This infrastructure is modularized into five main components:

1. **IAM**: Creates necessary IAM roles and policies for Lambda execution, cross-account access, and EventBridge scheduler permissions.
2. **Lambda**: Deploys the Python-based Lambda function that scans EBS volumes across accounts and generates reports.
3. **CloudWatch**: Sets up log groups with appropriate retention periods and KMS encryption for Lambda function logs.
4. **KMS**: Provides encryption keys for securing CloudWatch logs and other sensitive data.
5. **EventBridge**: Configures scheduled triggers to run the Lambda function on a defined schedule.
6. **SES**: Verifies email identities for sending audit reports to specified recipients.
7. **S3**: Used to store email csv reports for re-audits.

This approach provides a centralized and automated way to monitor EBS usage across your AWS organization, helping identify cost-saving opportunities and enforce storage governance policies.

---

## Architecture 

![Architecture](https://github.com/ACC-Automation/Multi-Account_EBS_Audit/blob/main/Monthly-Multi-Account_EBS_Audit.drawio.png)

---

## Project Structure

```bash
Multi-Account_EBS_Audit/
├── ebs_audit_processor/
│   ├── app.py              # Main Lambda handler function
│   ├── aws_clients.py      # AWS client initialization and session management
│   ├── ebs_utils.py        # EBS volume scanning and processing utilities
│   ├── email_utils.py      # Email formatting and sending functionality
│   └── s3_utils.py         # S3 operations for storing reports
├── modules/
│   ├── cloudwatch/
│   │   ├── main.tf         # CloudWatch log groups and metrics configuration
│   │   ├── output.tf       # CloudWatch resource outputs
│   │   └── variables.tf    # CloudWatch module variables
│   ├── eventbridge/
│   │   ├── main.tf         # EventBridge scheduler configuration
│   │   ├── output.tf       # EventBridge resource outputs
│   │   └── variables.tf    # EventBridge module variables
│   ├── iam/
│   │   ├── main.tf         # IAM roles and policies for Lambda and cross-account access
│   │   ├── output.tf       # IAM resource outputs
│   │   └── variables.tf    # IAM module variables
│   ├── kms/
│   │   ├── main.tf         # KMS key creation and policies
│   │   ├── output.tf       # KMS resource outputs
│   │   └── variables.tf    # KMS module variables
│   ├── lambda/
│   │   ├── main.tf         # Lambda function configuration and deployment
│   │   ├── output.tf       # Lambda resource outputs
│   │   └── variables.tf    # Lambda module variables
│   ├── s3/
│   │   ├── main.tf         # S3 bucket configuration for report storage
│   │   ├── output.tf       # S3 resource outputs
│   │   └── variables.tf    # S3 module variables
│   └── ses/
│       ├── main.tf         # SES email identity verification
│       ├── output.tf       # SES resource outputs
│       └── variables.tf    # SES module variables
├── backend.tf              # Terraform backend configuration
├── main.tf                 # Root module configuration
├── provider.tf             # AWS provider configuration
├── terraform.tfvars        # Terraform variable values
└── variables.tf            # Root module variable definitions
```

## Components

### 1. **IAM**

This component creates IAM roles and policies required for the solution:
- **Lambda Execution Role**: Allows the Lambda function to access necessary AWS services.
- **Cross-Account Role**: Defines the trust relationship for accessing target accounts.
- **EventBridge Scheduler Role**: Permits EventBridge to invoke the Lambda function.

Key tasks include:
- Creating IAM roles with appropriate trust relationships.
- Attaching policies for EC2 volume access, SES email sending, and cross-account role assumption.
- Setting up permissions for EventBridge to trigger Lambda functions.

### 2. **Lambda**

This component deploys the Lambda function that performs the EBS volume audit:
- Packages the Python code from the `ebs_audit_processor` directory.
- Configures environment variables for target accounts, regions, and email settings.
- Sets up appropriate timeout and memory allocation for multi-account scanning.

The Lambda function scans each target account and region for unattached EBS volumes, collects metadata, and generates a detailed HTML report.

### 3. **CloudWatch**

This module configures CloudWatch resources:
- Creates log groups for Lambda function logs with specified retention periods.
- Enables KMS encryption for log data security.
- Sets up appropriate log formats and levels for monitoring.

### 4. **KMS**

This component manages encryption keys:
- Creates a KMS key for encrypting CloudWatch logs.
- Configures key policies to allow appropriate service access.
- Enables automatic key rotation for enhanced security.

### 5. **EventBridge**

This module sets up scheduled execution:
- Creates an EventBridge scheduler to trigger the Lambda function.
- Configures cron expressions for defining the execution schedule.
- Sets up retry policies for reliable execution.

### 6. **SES**

This component handles email notifications:
- Verifies sender and recipient email addresses.
- Enables the Lambda function to send formatted HTML reports.
- Supports multiple recipient addresses for broader distribution of audit results.

### 7. **S3**

This module creates an S3 bucket to:
- Store the report in a csv format for re-audit purpose.

---

## Prerequisites

Before you begin, ensure the following prerequisites are met:

- **AWS Account**: You must have an active AWS account. If you don’t have one, you can sign up at [AWS Sign-Up](https://aws.amazon.com/).
- **AWS CLI**: AWS Command Line Interface (CLI) should be installed and configured. (Steps given below)
- **Terraform**: Terraform should be installed on your system. (Steps given below)

---
### Step 1: Install AWS CLI

#### 1.1. Install AWS CLI on Windows/Linux/MacOs

1. Follow the AWS official Documentation - [AWS CLI INSTALLER GUIDE](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html).
2. Once installed, verify the installation by running:

 ```bash
 aws --version
 ```
This should output the version of AWS CLI, confirming it’s successfully installed.

### Step 2: Set Up IAM User and Access Keys

To interact with AWS services through the CLI, you need AWS credentials (access key ID and secret access key). These credentials should be associated with an IAM user.

#### 2.1. Create an IAM User

1. Sign in to the AWS Management Console.
2. Navigate to IAM (Identity and Access Management) from the AWS console.
3. In the left-hand sidebar, click Users and then click the Add user button.
4. Provide a User name (e.g., Terraform-user).
5. On the Set permissions page, choose Attach policies directly.
6. Choose a policy, such as AdministratorAccess (or a more restrictive policy based on your use case).
7. Click Next: Tags (you can skip tagging, but it’s good practice for organizational purposes).
8. Review the configuration and click Create user.
9. Now, In the IAM dashboard, on the left-hand side, click on Users under the Access management section.
10. Click on the User you just created to generate the access keys.
11. In the user details page, click on the Security credentials tab.
12. Click the Create access key button. This will generate a new Access Key ID and Secret Access Key.
13. After the keys are generated, make sure to download the .csv file or copy the keys and store them securely.
    
Example:   
The file will contain :
- Access Key ID: `AKIAEXAMPLEKEY123`
- Secret Access Key: `wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY` 

> [!NOTE]
> Ensure to save the Access key ID and Secret access key that are generated. You won’t be able to retrieve them again.

### Step 3: Configure AWS CLI

Once you have your IAM user’s credentials, you can configure the AWS CLI.

#### 3.1. Run AWS CLI Configuration Command

Open a terminal in VS Code or Command Prompt on Windows and run the following command:

```bash
aws configure
```
This will prompt you to enter the following:

- AWS Access Key ID: Enter the access key ID obtained in Step 2.
- AWS Secret Access Key: Enter the secret access key obtained in Step 2.
- Default region name: Enter the AWS region you want to interact with (e.g., us-west-2, us-east-1). You can always change it later.
- Default output format: Choose your preferred output format. You can choose from:
  - json (default)
  - text
  - table
  - (Keep it Empty if not required)

Example:

```bash
AWS Access Key ID [None]: <your-access-key-id>
AWS Secret Access Key [None]: <your-secret-access-key>
Default region name [None]: us-west-2
Default output format [None]:
```

### Step 4: Install & Setup Terraform 

#### 4.1. Install Terraform on Windows/Linux/MacOS

Download Terraform:
Go to the [Terraform Downloads](https://developer.hashicorp.com/terraform/install) page and download the appropriate version for your OS.

**For Windows**
1. After downloading, extract the ZIP file to a directory of your choice. For example, you can extract it to C:\Terraform.
2. Right-click on 'This PC' (or 'Computer') and select Properties.
3. Click on Advanced system settings on the left.
4. In the System Properties window, click the Environment Variables button.
5. Under System variables, scroll down to select the Path variable and click Edit.
6. In the Edit Environment Variable dialog, click New and then add the path to the directory where you extracted Terraform (e.g., 
   C:\Terraform). For example, if you extracted Terraform to C:\Terraform, add C:\Terraform to your PATH.
7. Click OK to save and close all the dialogs.
8. Verify Installation: Open Command Prompt and run the following command:

```bash
terraform --version
```
If installed correctly, you should see the version of Terraform installed.

### Step 5: Configuring Backend

#### 5.1. Creating Backend S3 Bucket to store Terraform state file
 
 1. Navigate to S3 Console
 2. Click on the "Create bucket" Button
 3. Enter Bucket Name, choose a globally unique name for your S3 bucket. Example: my-terraform-bucket-123
 4. Select a Region, choose an AWS region where your bucket will reside.
 5. Set Bucket Configuration Options (Optional)
      - Versioning: You can enable versioning if you want to keep multiple versions of the same object in your bucket.
      - Tags: You can add metadata to the bucket by adding tags (key-value pairs).
      - Object Lock: If you need to enforce write once, read many (WORM) protection for the objects in the bucket, enable Object Lock.
      - Encryption: Enable encryption to automatically encrypt objects when they are uploaded to the bucket.
      - Advanced settings: Additional settings such as logging, website hosting, and replication.
 6. Review and Create.

## Provisioning

### 1. Clone the repository on your local machine

```bash
git clone <repository-url>
cd Multi-Account_EBS_Audit/
```
### 2. Adding backend configuration

 - In command prompt open the file `backend.tf` inside the project directory  OR  Open the project in VS Code (Or any other code editor) and open the file `backend.tf`.
 - In the `backend.tf` whick looks like this:

```hcl
terraform {
  backend "s3" {
    bucket         = "<your-backend-s3-bucket-name>" # Enter the name of the S3 bucket you created
    key            = "terraform.tfstate"
    region         = "<aws-region>" # Region of the Backend S3 Bucket you created
    encrypt        = true
  }
}
```

### 3. Configuring variables to meet custom requirements

 - Configuring Variables inside the `terraform.tfvars` file will help you achieve your requirement. Every detail is mentioned inside the `terraform.tfvars` file to help you achieve your requirement:

```hcl
# IAM
lambda_role_name     = "lambda-ebs-audit-role"  # Name of the IAM role that will be created for the Lambda function
assume_role_name     = "CrossAccountAuditRole"  # Name of the IAM role to assume in target accounts (must be created in each target account)
target_account_ids   = ["123456789012"]         # List of AWS account IDs to scan for unused EBS volumes
target_regions       = ["us-east-1","ap-south-1"] # AWS regions to scan within each target account

# Lambda
lambda_code_path_ebs_audit_processor = "./ebs_audit_processor"  # Path to the Lambda function code directory
lambda_function_name                 = "ebs-unused-volumes-audit"  # Name of the Lambda function to be created

# Email Configuration
sender_email     = "sender@example.com"                          # Email address that will send the audit reports (must be verified in SES)
recipient_email  = ["recipient1@example.com", "recipient2@example.com"]  # List of email addresses to receive the audit reports

# SES
verify_recipient = true  # Whether to verify recipient emails in SES (set true for sandbox mode, false for production)

# CloudWatch
retention_in_days = 30  # Number of days to retain Lambda function logs in CloudWatch

# KMS
enable_key_rotation         = true  # Whether to enable automatic rotation of the KMS key
kms_deletion_window_in_days = 7     # Waiting period before KMS key is deleted (between 7-30 days)

# Region
aws_region = "ap-south-1"  # AWS region where the resources will be deployed

# EventBridge
eventbridge_rule_name = "monthly-ebs-audit-trigger"  # Name of the EventBridge scheduler rule
cron_expression       = "cron(0 0 1 * ? *)"         # Schedule expression (this example: midnight on 1st day of each month)
schedule_expression_timezone = "Asia/Kolkata"       # Timezone for the cron expression
scheduler_group_name = "default"                    # EventBridge scheduler group name
maximum_retry_attempts = 5                          # Maximum number of retry attempts if Lambda invocation fails
maximum_event_age_in_seconds = 3600                 # How long an event remains valid for processing (1 hour)

# S3
s3_bucket_name = "ebs-unused-reports"   # Name of the S3 Bucket to store reports

# Tags
tags = {
  environment = "test"       # Environment tag for all resources
  owner       = "YourName"   # Owner tag for all resources
  vendor      = "YourCompany" # Vendor tag for all resources
  cost_center = "YourDept"   # Cost center tag for all resources
}
```
 - Everything is detailed out with the help of comments. 

**Flexible solution to choose number of Email Recipients, Target Accounts, Target Regions, Cron Schedule, Timezone**

### 4. Creating Trust Policy In Target Accounts

1. In each target AWS account that you want to audit, you need to create an IAM role that allows the Lambda function in your main account to access and scan EBS volumes.
 - **Role Name**: `CrossAccountAuditRole` (or the name specified in your `assume_role_name` variable).
 - **Trust Relationship**: Allows the Lambda role from your main account to assume this role.

##### Trust Policy

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::<LAMBDA_ACCOUNT_ID>:root"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
```

##### Permission Policy
 - Create a policy with the following permissions and attach it to the role:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ec2:DescribeVolumes",
        "ec2:DescribeTags"
      ],
      "Resource": "*"
    }
  ]
}
```
- For reference you can also see the "iam target role and policy.txt" file in the repository.

**After making the necessary changes make sure to save the files.**

> [!NOTE] 
> Before moving to the next steps make sure that terraform version and aws credentials are configured for created user  in the present 
> working directory by running the commands mentioned above for the same once again.

### 5. Deploying the Infrastructure

1. Initialize Terraform modules and backend.
```bash
terraform init
```
- Initializes a Terraform working directory. It downloads the necessary provider plugins and sets up the backend for storing state files. This command should be run first before any other Terraform commands.

2. Validate the Terraform Configuration
```bash
terraform validate
```
- Validates the configuration files in the current working directory to check for syntax errors or inconsistencies. It doesn't access any infrastructure; it only checks the configuration for correctness.

3. Plan the infrastructure
```bash
terraform plan
```
- Creates an execution plan, showing the actions Terraform will take to achieve the desired state as defined in the configuration files. It compares the current state with the desired configuration and shows what will be added, modified, or destroyed.

4. Deploying Infrastructure
```bash
terraform apply
```
- Applies the changes required to reach the desired state of the configuration. This command will prompt for confirmation before making any changes, and then it will create, update, or destroy resources according to the plan.

5. Check Deployment
- Login to the console and check if the deployed infrastructure meets your requirement. Also make sure to verify the email addresses you provided.

## Sample Output
You can manually Invoke the lambda function to check if respective people recieve the email. The Output should look like the following:

![Sample_Output](https://github.com/ACC-Automation/Multi-Account_EBS_Audit/blob/main/EBS%20Mail%20Output.jpeg)

---

> **Warning:**  
> The following command **DESTROYS ALL RESOURCES** in your environment. It should only be used after proper approvals and severity checks.

```bash
terraform destroy
```
**Destroys all the resources managed by Terraform. It is used to clean up infrastructure that is no longer needed.**

---
## Clean Up

- Once the resources have been provisioned, follow these steps to ensure stability and prevent accidental destruction:
    - Monitor for 1-2 Weeks: After provisioning, monitor the resources and configurations for a period of 1-2 weeks to ensure they are functioning as required and meet the project's objectives.
    
    - Validation: During this monitoring phase, verify that everything is operating successfully and according to the defined requirements.
    
    - Delete User and Backend S3 Bucket: If the resources are confirmed to be stable and working as expected after the monitoring period:
      - Delete the User: Ensure that the user associated with provisioning access is removed.
      - Delete the Backend S3 Bucket: Safeguard against any future accidental resource destruction by removing the S3 bucket used for storing the Terraform state files.

- This approach ensures that your resources are correctly set up, monitored for performance, and protected from inadvertent deletion once they are confirmed to be stable.