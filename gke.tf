resource "google_container_cluster" "this" {
  name       = var.cluster_name
  location   = var.region
  network    = var.network_name
  subnetwork = var.subnet_name

  min_master_version       = data.google_container_engine_versions.gke_version.latest_master_version
  initial_node_count       = 1
  remove_default_node_pool = true

  master_auth {
    client_certificate_config {
      issue_client_certificate = false
    }
  }

  addons_config {
    gce_persistent_disk_csi_driver_config {
      enabled = true
    }
    gcs_fuse_csi_driver_config {
      enabled = true
    }
  }

  workload_identity_config { // required for fuse csi driver
    workload_pool = "${var.project_id}.svc.id.goog"
  }

  ip_allocation_policy {
    cluster_secondary_range_name  = var.secondary_ip_range_name_for_pods
    services_secondary_range_name = var.secondary_ip_range_name_for_services
  }

  logging_service = "none"
}
