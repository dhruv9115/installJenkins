variable "AWS_REGION" {
  default = "us-east-1"
}

variable "PATH_TO_PRIVATE_KEY" {
  default = "mykey"
}

variable "PATH_TO_PUBLIC_KEY" {
  default = "mykey.pub"
}

variable "ENV" {
  default = "prod"
}

variable "ansible_user" {
  default = "ubuntu"
}

variable "profile" {
  default = "terraform_iam_user"
}

variable "private_key" {
  default = "~/.ssh/MyKeyPair.pem"
}

