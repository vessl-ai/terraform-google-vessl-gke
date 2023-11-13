data "google_container_engine_versions" "gke_version" {
  project        = var.project_id
  location       = var.region
  version_prefix = endswith(var.kubernetes_version, ".") ? var.kubernetes_version : "${var.kubernetes_version}."
}

locals {
  node_oauth_scopes = [
    "https://www.googleapis.com/auth/devstorage.read_only",
    "https://www.googleapis.com/auth/ndev.clouddns.readwrite",
    "https://www.googleapis.com/auth/compute",
    "https://www.googleapis.com/auth/logging.write",
    "https://www.googleapis.com/auth/monitoring",
    "https://www.googleapis.com/auth/servicecontrol",
    "https://www.googleapis.com/auth/service.management.readonly",
    "https://www.googleapis.com/auth/trace.append",
  ]
}