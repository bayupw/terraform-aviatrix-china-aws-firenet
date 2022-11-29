module "aliyun_spoke1" {
  source  = "terraform-aviatrix-modules/mc-spoke/aviatrix"
  version = "1.4.2"

  cloud      = "ali"
  account    = var.aliyun_account
  region     = var.aliyun_region
  name       = "${var.name_suffix}-gia-ali-spoke1"
  cidr       = "10.1.0.0/24"
  ha_gw      = var.ha_gw
  enable_bgp = false
  transit_gw = module.aws_transit_firenet.transit_gateway.gw_name
}

module "aliyun_spoke2" {
  source  = "terraform-aviatrix-modules/mc-spoke/aviatrix"
  version = "1.4.2"

  cloud      = "ali"
  account    = var.aliyun_account
  region     = var.aliyun_region
  name       = "${var.name_suffix}-gia-ali-spoke2"
  cidr       = "10.2.0.0/24"
  ha_gw      = var.ha_gw
  enable_bgp = false
  transit_gw = module.aws_transit_firenet.transit_gateway.gw_name
}