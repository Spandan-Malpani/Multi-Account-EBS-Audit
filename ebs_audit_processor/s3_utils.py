import boto3
from datetime import datetime, timezone

def save_csv_report_to_s3(csv_content, bucket_name):
    s3 = boto3.client("s3")
    # Use timezone-aware UTC datetime now()
    date_str = datetime.now(timezone.utc).strftime("%Y-%m-%d")
    file_name = f"ebs-unused-report-{date_str}.csv"

    s3.put_object(
        Bucket=bucket_name,
        Key=file_name,
        Body=csv_content,
        ContentType="text/csv"
    )
