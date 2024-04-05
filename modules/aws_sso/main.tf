# Data source to retrieve information about AWS Single Sign-On (SSO) instances.
data "aws_ssoadmin_instances" "SSO_Instance" {}

# AWS identity store groups to organize users.
resource "aws_identitystore_group" "groups" {
  count             = length(var.group_name)
  display_name      = var.group_name[count.index]
  description       = count.index == 0 ? "Digidense-Admin group will be created" : "Digidense-Read group will be created"
  identity_store_id = tolist(data.aws_ssoadmin_instances.SSO_Instance.identity_store_ids)[0]
}

# AWS identity store users.
resource "aws_identitystore_user" "users" {
  count             = length(var.user_name)
  identity_store_id = tolist(data.aws_ssoadmin_instances.SSO_Instance.identity_store_ids)[0]
  display_name      = "${var.user_dname[count.index]} ${var.user_fname[count.index]}"
  user_name         = var.user_name[count.index]

  name {
    given_name  = var.user_dname[count.index]
    family_name = var.user_fname[count.index]
  }

  emails {
    value = var.user_email[count.index]
  }
}

# Attaches users to groups in the AWS identity store.
resource "aws_identitystore_group_membership" "group_attachment" {
  count             = length(aws_identitystore_group.groups) * length(aws_identitystore_user.users)
  identity_store_id = tolist(data.aws_ssoadmin_instances.SSO_Instance.identity_store_ids)[0]
  group_id          = split("/", aws_identitystore_group.groups[floor(count.index / length(aws_identitystore_user.users))].id)[1]
  member_id         = split("/", aws_identitystore_user.users[count.index % length(aws_identitystore_user.users)].id)[1]
}


# AWS SSO Admin permission sets.
resource "aws_ssoadmin_permission_set" "permission_sets" {
  for_each = {
    Dev_Permission  = var.permission_set_name[0]
    Prod_Permission = var.permission_set_name[1]
  }
  name             = each.value
  instance_arn     = tolist(data.aws_ssoadmin_instances.SSO_Instance.arns)[0]
  session_duration = "PT12H"
}

# Local values for AWS managed policies to create Admin and Readonly Access.
locals {
  aws_managed_policies_dev = [
    "arn:aws:iam::aws:policy/AdministratorAccess",
  ]
  aws_managed_policies_prod = [
    "arn:aws:iam::aws:policy/ReadOnlyAccess",
  ]
}

# Attaches AWS managed policies to permission sets in AWS SSO Admin.
resource "aws_ssoadmin_managed_policy_attachment" "managed_policies" {
  for_each = merge(
    {
      for idx, policy_dev in local.aws_managed_policies_dev : "Dev_${idx}" => {
        managed_policy_arn = policy_dev
        permission_set_arn = aws_ssoadmin_permission_set.permission_sets["Dev_Permission"].arn
      }
    },
    {
      for idx, policy_prod in local.aws_managed_policies_prod : "Prod_${idx}" => {
        managed_policy_arn = policy_prod
        permission_set_arn = aws_ssoadmin_permission_set.permission_sets["Prod_Permission"].arn
      }
    }
  )
  instance_arn       = tolist(data.aws_ssoadmin_instances.SSO_Instance.arns)[0]
  managed_policy_arn = each.value.managed_policy_arn
  permission_set_arn = each.value.permission_set_arn
}

# Assigns AWS accounts to AWS SSO permission sets for the dev environment.
resource "aws_ssoadmin_account_assignment" "addition-mobile-dev-assign" {
  count              = length(var.group_name)
  instance_arn       = tolist(data.aws_ssoadmin_instances.SSO_Instance.arns)[0]
  permission_set_arn = aws_ssoadmin_permission_set.permission_sets["Dev_Permission"].arn
  principal_id       = split("/", aws_identitystore_group.groups[count.index].id)[1]
  principal_type     = "GROUP"
  target_id          = var.aws_account_id[0]
  target_type        = "AWS_ACCOUNT"
}

# Assigns AWS accounts to AWS SSO permission sets for the prod environment.
resource "aws_ssoadmin_account_assignment" "addition-mobile-pro-assign" {
  count              = length(var.group_name)
  instance_arn       = tolist(data.aws_ssoadmin_instances.SSO_Instance.arns)[0]
  permission_set_arn = aws_ssoadmin_permission_set.permission_sets["Prod_Permission"].arn
  principal_id       = split("/", aws_identitystore_group.groups[count.index].id)[1]
  principal_type     = "GROUP"
  target_id          = var.aws_account_id[1]
  target_type        = "AWS_ACCOUNT"
}





