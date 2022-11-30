module "aws_transit_firenet" {
  source  = "terraform-aviatrix-modules/mc-transit/aviatrix"
  version = "2.3.1"

  cloud                  = "aws"
  account                = var.aws_account
  region                 = var.aws_region
  name                   = "${var.name_suffix}-gia-aws-firenet"
  cidr                   = "10.100.0.0/23"
  ha_gw                  = var.ha_gw
  instance_size          = "c5.xlarge"
  enable_transit_firenet = true
  single_az_ha           = false
}

module "pan_s3_bootstrap" {
  source  = "bayupw/pan-bootstrap-aviatrix/aws"
  version = "1.0.2"

  bootstrap_bucket = "${var.name_suffix}-pan-bootstrap"
  create_admin_api = false
}

#
# Cannot use mc-firenet module until this issue is fixed > https://github.com/terraform-aviatrix-modules/terraform-aviatrix-mc-firenet/issues/12
# see aws-china-firenet.tf for firenet related code
#
# module "aws_firenet" {
#   source  = "terraform-aviatrix-modules/mc-firenet/aviatrix"
#   version = "v1.3.0"

#   transit_module         = module.aws_transit_firenet
#   firewall_image         = var.firewall_image
#   firewall_image_version = var.firewall_image_version
#   firewall_image_id      = var.firewall_image_id
# }