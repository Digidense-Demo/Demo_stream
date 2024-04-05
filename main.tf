module "aws_sso" {
  source              = "./modules/aws_sso"
  group_name          = var.group_name
  user_name           = var.user_name
  user_dname          = var.user_dname
  user_fname          = var.user_fname
  user_email          = var.user_email
  permission_set_name = var.permission_set_name
  aws_account_id      = var.aws_account_id

}
