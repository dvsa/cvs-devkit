resource "aws_s3_bucket" "signature" {
  bucket = "cvs-signature"
  acl    = "private"
}