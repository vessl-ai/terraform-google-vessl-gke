resource "google_container_node_pool" "manager" {
  depends_on = [
    google_container_cluster.this,
    google_service_account.cluster_service_account,
  ]

  project        = var.project_id
  location       = var.region
  node_locations = length(var.manager_node_pool_config.zones) > 0 ? var.manager_node_pool_config.zones : var.zones

  name    = var.manager_node_pool_config.name
  cluster = google_container_cluster.this.name
  version = google_container_cluster.this.node_version

  node_config {
    machine_type = var.manager_node_pool_config.machine_type
    image_type   = "COS_CONTAINERD"
    disk_type    = var.manager_node_pool_config.disk_type
    disk_size_gb = var.manager_node_pool_config.disk_size_gb

    gcfs_config {
      enabled = true
    }

    labels = {
      "v1.k8s.vessl.ai/managed"   = "true"
      "v1.k8s.vessl.ai/dedicated" = "manager"
    }

    oauth_scopes    = local.node_oauth_scopes
    service_account = google_service_account.cluster_service_account.email
  }

  network_config {
    enable_private_nodes = false
  }

  initial_node_count = 0
  autoscaling {
    total_min_node_count = var.manager_node_pool_config.node_count
    total_max_node_count = var.manager_node_pool_config.node_count + 2
  }
}
