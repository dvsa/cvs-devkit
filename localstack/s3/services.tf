resource "aws_s3_bucket" "signature" {
  bucket = "cvs-signature"
  acl    = "private"
}


resource "aws_s3_bucket" "cert_gen" {
  bucket = "cvs-cert-gen"
  acl    = "private"
}