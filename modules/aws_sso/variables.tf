variable "group_name" {
  type        = list(string)
  description = "this variable for group"
  default     = ["Digidense-Admin", "Digidense-Read"]
}

variable "user_dname" {
  type        = list(string)
  description = "this variable for user display name"
  default     = ["Ashwini", "Anisha", "Akhilesh", "Rahul"]
}

variable "user_fname" {
  type        = list(string)
  description = "this variable for user display name"
  default     = ["K", "W", "M L", "R"]
}

variable "user_name" {
  type        = list(string)
  description = "this variable for user name"
  default     = ["Ashwini_Admin", "Anisha_Admin", "Akhilesh_Admin", "Rahul_Admin"]
}

variable "user_email" {
  type        = list(string)
  description = "this variable for user email"
  default     = ["ashwinikanagaraj3@gmail.com", "anishacsc2001@gmail.com", "akhilesh.mony@digidense.in", "rahul.russelraj@digidense.in"]
}

variable "permission_set_name" {
  type        = list(string)
  description = "this variable for dev permission account"
  default     = ["Dev_Permission_Set", "Prod_Permission_Set"]
}

variable "aws_account_id" {
  type        = list(string)
  description = "this variable for user1 id"
  default     = ["637423445967", "851725610908"]
}