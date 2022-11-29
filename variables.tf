# cn-north-1 = Beijing | cn-northwest-1 = Ningxia
variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "cn-north-1"
}

variable "aliyun_region" {
  description = "Alibaba Cloud region"
  type        = string
  default     = "acs-cn-shanghai (Shanghai)"
}

variable "aws_account" {
  description = "AWS access account in Aviatrix"
  type        = string
  default     = "aws-china-account"
}

variable "aliyun_account" {
  description = "Alibaba Cloud access account in Aviatrix"
  type        = string
  default     = "aliyun-account"
}

variable "name_suffix" {
  description = "Name suffix for tags"
  type        = string
  default     = "avx"
}

variable "fw_instance_size" {
  description = "Name suffix for tags"
  type        = string
  default     = "m5.xlarge"
}

variable "ha_gw" {
  description = "Enable Aviatrix HA Gateway"
  type        = bool
  default     = true
}

variable "enable_transit_firenet" {
  description = "Enable Transit Firenet"
  type        = bool
  default     = true
}

variable "firewall_image" {
  description = "The firewall image to be used to deploy the NGFW's"
  type        = string
  default     = "Palo Alto Networks VM-Series Next-Generation Firewall (BYOL)"
}

variable "firewall_image_version" {
  description = "The software version to be used to deploy the NGFW's"
  type        = string
  default     = "10.0.4"
}

variable "firewall_image_id" {
  description = "Firewall image ID."
  type        = string
  default     = "ami-01286e9ef78c6d545"
}

variable "firewall_user" {
  description = "Firewall username for vendor integration."
  type        = string
}

variable "firewall_password" {
  description = "Firewall password for vendor integration."
  type        = string
}

variable "inspection_enabled" {
  description = "Enable east-west inspection"
  type        = bool
  default     = true
}

variable "egress_enabled" {
  description = "Enable egress inspection"
  type        = bool
  default     = false
}

variable "keep_alive_via_lan_interface_enabled" {
  description = "Enable Keep Alive via Firewall LAN Interface"
  type        = bool
  default     = false
}