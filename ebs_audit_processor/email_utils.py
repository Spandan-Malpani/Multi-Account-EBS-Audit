import boto3

def send_email(sender_email, recipient_email, html_body, region="ap-south-1"):
    ses = boto3.client("ses", region_name=region)
    
    if isinstance(recipient_email, list):
        to_addresses = recipient_email
    else:
        to_addresses = [recipient_email]
    ses.send_email(
        Source=sender_email,
        Destination={"ToAddresses": to_addresses},
        Message={
            "Subject": {"Data": "Unused EBS Volumes Report"},
            "Body": {"Html": {"Data": html_body}}
        }
    )
