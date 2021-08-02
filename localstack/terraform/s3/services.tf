resource "aws_s3_bucket" "signature" {
  bucket = "cvs-signature-localstack"
  acl    = "private"
}


resource "aws_s3_bucket" "cert_gen" {
  bucket = "cvs-cert-localstack"
  acl    = "private"
}