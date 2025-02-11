/*terraform {
  required_providers {
    aws = {
      source = "value"
      version = "value"
    }
  }
}*/


provider "aws" {
  region = "us-east-1"
  access_key = var.access_key
  secret_key = var.scerect_key
}


module "Main-vpc" {
  source = "./Modules/Vpc"
}

