variable "project_id" {}
variable "cluster_name" {}
variable "kubernetes_version" {}
variable "region" {}
variable "zones" {}
variable "network_name" {}
variable "subnet_name" {}
variable "secondary_ip_range_pods" {
  default = "pods"
}
variable "secondary_ip_range_services" {
  default = "services"
}
variable "grant_registry_access" {
  default = false
}

variable "manager_node_pool_config" {
  type = object({
    name         = optional(string)
    node_count   = optional(number)
    machine_type = optional(string)
    disk_size_gb = optional(number)
    disk_type    = optional(string)
    zones        = optional(list(string))
  })
  default = {
    name         = "manager"
    node_count   = 2
    machine_type = "e2-medium"
    disk_size_gb = 300
    disk_type    = "pd-balanced"
    zones        = []
  }
}
