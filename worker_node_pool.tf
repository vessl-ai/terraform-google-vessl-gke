resource "google_container_node_pool" "workers" {
  for_each = var.worker_node_pool_configs
  depends_on = [
    google_container_cluster.this,
    google_service_account.cluster_service_account,
  ]
  project        = var.project_id
  location       = var.region
  node_locations = length(each.value.zones) > 0 ? each.value.zones : var.zones

  name    = each.value.name
  cluster = google_container_cluster.this.name
  version = google_container_cluster.this.node_version

  node_config {
    machine_type = each.value.machine_type
    image_type   = "UBUNTU_CONTAINERD"
    disk_type    = each.value.disk_type
    disk_size_gb = each.value.disk_size_gb

    gcfs_config {
      enabled = true
    }

    labels = {
      "v1.k8s.vessl.ai/managed" = "true"
    }

    oauth_scopes    = local.node_oauth_scopes
    service_account = google_service_account.cluster_service_account.email

    dynamic "guest_accelerator" {
      for_each = each.value.accelerator_type == null ? [] : ["dummy"]
      content {
        type               = each.value.accelerator_type
        count              = each.value.accelerator_count == null ? 1 : each.value.accelerator_count
        gpu_partition_size = null
        gpu_sharing_config = null
        gpu_driver_installation_config {
          gpu_driver_version = "INSTALLATION_DISABLED"
        }
      }
    }
  }

  network_config {
    enable_private_nodes = false
  }

  initial_node_count = each.value.total_min_count
  autoscaling {
    total_min_node_count = each.value.total_min_count
    total_max_node_count = each.value.total_max_count
  }
}
