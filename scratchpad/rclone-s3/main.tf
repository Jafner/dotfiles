# terraform
# ^Brb9%10sS#OPNU%^Km@DTOwoF!nRxQy%Kc#Au_q!1^&T2%M1DR5G_
# Scoring-Tremor-Dreamy1-Aroma-Stew-Scanning
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  backend "s3" {
    bucket = "jafner-net-terraform"
    region = "us-west-2"
    key = "rclone.tfstate"
    encrypt = true
    use_lockfile = true
  }
}

provider "aws" {
  region = "us-west-2"
}

resource "aws_s3_bucket" "rclone" {
  bucket = "rclone-s3"
}

resource "aws_s3_bucket_versioning" "main" {
  bucket = aws_s3_bucket.rclone.id
  versioning_configuration {
    status = "Enabled"
  }
}
