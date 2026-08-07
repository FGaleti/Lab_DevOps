terraform {
    backend "s3" {
        bucket = "bucket-terraform-felipe-gongora"
        key    = "site/terraform.tfstate"
        region = "us-east-1"
        encrypt = true
        use_lockfile = true
    }
}