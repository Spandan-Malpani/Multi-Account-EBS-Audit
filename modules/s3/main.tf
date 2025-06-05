resource "aws_s3_bucket" "ebs_reports_bucket" {
  bucket = var.s3_bucket_name

  tags = merge(var.tags, {
    Name = "${var.s3_bucket_name}"
  })
}