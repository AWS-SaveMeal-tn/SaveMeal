terraform {
  required_version = ">= 1.6.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.31.0"
    }
  }

  # State local : volontaire. L'infra est détruite à chaque TP (terraform destroy),
  # donc pas de backend S3/DynamoDB à maintenir ni à payer.
}

provider "aws" {
  region = var.aws_region # us-east-1 imposé par le Learner Lab

  # Credentials : profil [default] dans ~/.aws/credentials (Learner Lab : Session Token
  # à renouveler à chaque session) ou variables AWS_ACCESS_KEY_ID / AWS_SECRET_ACCESS_KEY /
  # AWS_SESSION_TOKEN.

  default_tags {
    tags = {
      Project     = var.project_name
      Environment = var.environment
      ManagedBy   = "terraform"
    }
  }
}
