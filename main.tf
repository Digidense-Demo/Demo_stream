module "kms_key" {
  source                  = "./modules/aws_kms"
  aliases_name            = var.aliases_name
  description             = var.description
  deletion_window_in_days = var.deletion_window_in_days
  enable_key_rotation     = var.enable_key_rotation
}

