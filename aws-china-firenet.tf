resource "aviatrix_firewall_instance" "firewall_instance_1" {
  count = var.enable_transit_firenet ? 1 : 0

  vpc_id                 = module.aws_transit_firenet.vpc.vpc_id
  firewall_name          = "${var.name_suffix}-az1-fw"
  firewall_size          = var.fw_instance_size
  firewall_image         = var.firewall_image
  firewall_image_version = var.firewall_image_version
  firewall_image_id      = var.firewall_image_id
  firenet_gw_name        = module.aws_transit_firenet.transit_gateway.gw_name
  egress_subnet          = module.aws_transit_firenet.vpc.public_subnets[1].cidr
  management_subnet      = module.aws_transit_firenet.vpc.public_subnets[1].cidr

  iam_role              = module.pan_s3_bootstrap.aws_iam_instance_profile.name
  bootstrap_bucket_name = module.pan_s3_bootstrap.aws_s3_bucket.bucket

  lifecycle {
    ignore_changes = [firewall_image_version, firewall_size]
  }
}

resource "aviatrix_firewall_instance_association" "firenet_instance1" {
  count = var.enable_transit_firenet ? 1 : 0

  vpc_id               = module.aws_transit_firenet.vpc.vpc_id
  firenet_gw_name      = module.aws_transit_firenet.transit_gateway.gw_name
  instance_id          = aviatrix_firewall_instance.firewall_instance_1[0].instance_id
  firewall_name        = aviatrix_firewall_instance.firewall_instance_1[0].firewall_name
  lan_interface        = aviatrix_firewall_instance.firewall_instance_1[0].lan_interface
  management_interface = aviatrix_firewall_instance.firewall_instance_1[0].management_interface
  egress_interface     = aviatrix_firewall_instance.firewall_instance_1[0].egress_interface
  attached             = true
}

resource "aviatrix_firenet" "firenet" {
  vpc_id                               = module.aws_transit_firenet.vpc.vpc_id
  inspection_enabled                   = var.inspection_enabled
  egress_enabled                       = var.egress_enabled
  keep_alive_via_lan_interface_enabled = var.keep_alive_via_lan_interface_enabled
  manage_firewall_instance_association = false

  depends_on = [aviatrix_firewall_instance_association.firenet_instance1]
}

# Spoke1 FireNet Policy
resource "aviatrix_transit_firenet_policy" "aliyun_spoke1_firenet_policy" {
  transit_firenet_gateway_name = module.aws_transit_firenet.transit_gateway.gw_name
  inspected_resource_name      = "SPOKE:${module.aliyun_spoke1.spoke_gateway.gw_name}"
  depends_on                   = [module.aliyun_spoke1]
}

# Spoke2 FireNet Policy
resource "aviatrix_transit_firenet_policy" "aliyun_spoke2_firenet_policy" {
  transit_firenet_gateway_name = module.aws_transit_firenet.transit_gateway.gw_name
  inspected_resource_name      = "SPOKE:${module.aliyun_spoke2.spoke_gateway.gw_name}"
  depends_on                   = [module.aliyun_spoke2]
}

# wait for after firewall instance is launched, before running vendor integration
resource "time_sleep" "wait_fw_instance" {
  create_duration = "15m"
  depends_on      = [aviatrix_firewall_instance.firewall_instance_1]
}

# Aviatrix FireNet Vendor Integration Data Source
data "aviatrix_firenet_vendor_integration" "firewall_instance_1" {
  vendor_type   = "Palo Alto Networks VM-Series"
  vpc_id        = module.aws_transit_firenet.vpc.vpc_id
  instance_id   = aviatrix_firewall_instance.firewall_instance_1[0].instance_id
  public_ip     = aviatrix_firewall_instance.firewall_instance_1[0].public_ip
  firewall_name = aviatrix_firewall_instance.firewall_instance_1[0].firewall_name
  username      = var.firewall_user
  password      = var.firewall_password
  save          = true

  depends_on = [time_sleep.wait_fw_instance]
}