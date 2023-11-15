variable "project_id" {}
variable "cluster_name" {}
variable "kubernetes_version" {}
variable "region" {}
variable "zones" {}
variable "network_name" {}
variable "subnet_name" {}
variable "secondary_ip_range_name_for_pods" {
  default = "pods"
}
variable "secondary_ip_range_name_for_services" {
  default = "services"
}
variable "grant_registry_access" {
  default = false
}

variable "manager_node_pool_config" {
  type = object({
    name         = optional(string, "manager")
    node_count   = optional(number, 2)
    machine_type = optional(string, "e2-medium")
    disk_size_gb = optional(number, 300)
    disk_type    = optional(string, "pd-balanced")
    zones        = optional(list(string), [])
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

variable "worker_node_pool_configs" {
  type = list(object({
    name              = string
    total_min_count   = number
    total_max_count   = number
    machine_type      = optional(string, "e2-medium")
    disk_size_gb      = optional(number, 300)
    disk_type         = optional(string, "pd-balanced")
    zones             = optional(list(string), [])
    accelerator_type  = optional(string, null) // `gcloud compute accelerator-types list`
    accelerator_count = optional(number, null)
    labels            = optional(map(string), {})
  }))
  default = []
}