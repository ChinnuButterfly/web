terraform {
  required_version = ">= 0.13"
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
    region = "us-east-1"
    access_key = "AKIARQCIKCTM6ONPZDME"
    secret_key = "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"

}