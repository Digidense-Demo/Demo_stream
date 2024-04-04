terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.40.0"
    }
  }
}
provider "aws" {
  region     = "us-east-1"
  access_key = "AKIAVRUVWAXYDX3D4E5U"
  secret_key = "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"
}