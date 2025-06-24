terraform {
  backend "s3" {
    bucket         = "ecs-backend-terraform-threat-3276327692586"
    key            = "global/s3/terraform.tfstate"
    region         = "eu-west-2"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
