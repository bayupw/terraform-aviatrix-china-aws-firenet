output "ecs_spoke1_public_ssh" {
  value = var.create_ecs ? "ssh root@${try(alicloud_instance.spoke1_public[0].public_ip, "")}" : ""
}

output "ecs_spoke1_private_ssh" {
  value = var.create_ecs ? "ssh root@${try(alicloud_instance.spoke1_private[0].private_ip, "")}" : ""
}

output "ecs_spoke2_public_ssh" {
  value = var.create_ecs ? "ssh root@${try(alicloud_instance.spoke2_public[0].public_ip, "")}" : ""
}

output "ecs_spoke2_private_ssh" {
  value = var.create_ecs ? "ssh root@${try(alicloud_instance.spoke2_private[0].private_ip, "")}" : ""
}

output "ecs_ssh_password" {
  value = var.create_ecs ? var.ecs_password : ""
}

output "firewall_instance_1_public_ip" {
  value = var.enable_transit_firenet ? "https://${aviatrix_firewall_instance.firewall_instance_1[0].public_ip}" : ""
}

output "firewall_instance_1_username_password" {
  value = var.enable_transit_firenet ? "${var.firewall_user}/${var.firewall_password}" : ""
}