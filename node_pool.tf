resource "google_container_node_pool" "manager" {
  project  = var.project_id
  location = var.region

  name    = var.manager_node_pool_config.name
  cluster = var.cluster_name
  version = data.google_container_engine_versions.gke_version.latest_master_version

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

  initial_node_count = var.manager_node_pool_config.node_count
  autoscaling {
    min_node_count = var.manager_node_pool_config.node_count
    max_node_count = var.manager_node_pool_config.node_count + 2
  }
}