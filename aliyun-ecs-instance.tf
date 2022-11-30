
data "http" "myip" {
  url = "http://ifconfig.me"
}

resource "alicloud_security_group" "spoke1" {
  count = var.create_ecs ? 1 : 0

  name        = "${var.name_suffix}-spoke1-sg"
  description = "${var.name_suffix} spoke 1 security group"
  vpc_id      = module.aliyun_spoke1.vpc.vpc_id
}

resource "alicloud_security_group" "spoke2" {
  count = var.create_ecs ? 1 : 0

  name        = "${var.name_suffix}-spoke2-sg"
  description = "${var.name_suffix} spoke 2 security group"
  vpc_id      = module.aliyun_spoke2.vpc.vpc_id
}

resource "alicloud_security_group_rule" "spoke1" {
  for_each = {
    for name, rules in local.sg_rules : name => rules
    if var.create_ecs == true
  }

  security_group_id = alicloud_security_group.spoke1[0].id
  priority          = 1
  type              = "ingress"
  policy            = "accept"
  ip_protocol       = each.value[0]
  port_range        = each.value[1]
  cidr_ip           = each.value[2]
}

resource "alicloud_security_group_rule" "spoke2" {
  for_each = {
    for name, rules in local.sg_rules : name => rules
    if var.create_ecs == true
  }

  security_group_id = alicloud_security_group.spoke2[0].id
  priority          = 1
  type              = "ingress"
  policy            = "accept"
  ip_protocol       = each.value[0]
  port_range        = each.value[1]
  cidr_ip           = each.value[2]
}

resource "alicloud_instance" "spoke1_public" {
  count = var.create_ecs ? 1 : 0

  vswitch_id        = module.aliyun_spoke1.vpc.public_subnets[0].subnet_id
  availability_zone = "${var.alicloud_region}-${element(split("-", module.aliyun_spoke1.vpc.public_subnets[0].name), length(split("-", module.aliyun_spoke1.vpc.public_subnets[0].name)) - 1)}"
  security_groups   = [alicloud_security_group.spoke1[0].id]

  instance_name              = "${var.name_suffix}-spoke1-public"
  host_name                  = "${var.name_suffix}-spoke1-public"
  instance_type              = "ecs.t6-c2m1.large"
  image_id                   = "ubuntu_22_04_x64_20G_alibase_20221104.vhd"
  internet_max_bandwidth_out = 1
  password                   = var.ecs_password
}

resource "alicloud_instance" "spoke1_private" {
  count = var.create_ecs ? 1 : 0

  vswitch_id        = module.aliyun_spoke1.vpc.public_subnets[1].subnet_id
  availability_zone = "${var.alicloud_region}-${element(split("-", module.aliyun_spoke1.vpc.public_subnets[1].name), length(split("-", module.aliyun_spoke1.vpc.public_subnets[1].name)) - 1)}"
  security_groups   = [alicloud_security_group.spoke1[0].id]

  instance_name              = "${var.name_suffix}-spoke1-private"
  host_name                  = "${var.name_suffix}-spoke1-private"
  instance_type              = "ecs.t6-c2m1.large"
  image_id                   = "ubuntu_22_04_x64_20G_alibase_20221104.vhd"
  internet_max_bandwidth_out = 0
  password                   = var.ecs_password
}

resource "alicloud_instance" "spoke2_public" {
  count = var.create_ecs ? 1 : 0

  vswitch_id        = module.aliyun_spoke2.vpc.public_subnets[0].subnet_id
  availability_zone = "${var.alicloud_region}-${element(split("-", module.aliyun_spoke1.vpc.public_subnets[0].name), length(split("-", module.aliyun_spoke1.vpc.public_subnets[0].name)) - 1)}"
  security_groups   = [alicloud_security_group.spoke2[0].id]

  instance_name              = "${var.name_suffix}-spoke2-public"
  host_name                  = "${var.name_suffix}-spoke2-public"
  instance_type              = "ecs.t6-c2m1.large"
  image_id                   = "ubuntu_22_04_x64_20G_alibase_20221104.vhd"
  internet_max_bandwidth_out = 1
  password                   = var.ecs_password
}

resource "alicloud_instance" "spoke2_private" {
  count = var.create_ecs ? 1 : 0

  vswitch_id        = module.aliyun_spoke2.vpc.public_subnets[1].subnet_id
  availability_zone = "${var.alicloud_region}-${element(split("-", module.aliyun_spoke2.vpc.public_subnets[1].name), length(split("-", module.aliyun_spoke1.vpc.public_subnets[1].name)) - 1)}"
  security_groups   = [alicloud_security_group.spoke2[0].id]

  instance_name              = "${var.name_suffix}-spoke2-private"
  host_name                  = "${var.name_suffix}-spoke2-private"
  instance_type              = "ecs.t6-c2m1.large"
  image_id                   = "ubuntu_22_04_x64_20G_alibase_20221104.vhd"
  internet_max_bandwidth_out = 0
  password                   = var.ecs_password
}

locals {
  sg_rules = {
    # name        = [ip_protocol, port_range, cidr_ip]
    any-icmp      = ["icmp", "-1/-1", "0.0.0.0/0"]
    ssh-rfc1918-1 = ["tcp", "22/22", "10.0.0.0/8"]
    ssh-rfc1918-2 = ["tcp", "22/22", "172.16.0.0/12"]
    ssh-rfc1918-3 = ["tcp", "22/22", "192.168.0.0/16"]
    ssh-myip      = ["tcp", "22/22", "${chomp(data.http.myip.response_body)}/32"]
  }
}