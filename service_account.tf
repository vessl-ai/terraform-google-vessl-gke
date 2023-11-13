locals {
  service_account_name   = "tf-gke-${substr(var.cluster_name, 0, min(15, length(var.cluster_name)))}-${random_string.cluster_service_account_suffix.result}"
  registry_projects_list = [var.project_id]
}

resource "random_string" "cluster_service_account_suffix" {
  upper   = false
  lower   = true
  special = false
  length  = 4
}

resource "google_service_account" "cluster_service_account" {
  project      = var.project_id
  account_id   = local.service_account_name
  display_name = "Terraform-managed service account for cluster ${var.cluster_name}"
}

resource "google_project_iam_member" "cluster_service_account_node_service_account" {
  project = google_service_account.cluster_service_account.project
  role    = "roles/container.nodeServiceAccount"
  member  = google_service_account.cluster_service_account.member
}

resource "google_project_iam_member" "cluster_service_account_gcr" {
  count   = var.grant_registry_access ? 1 : 0
  project = var.project_id
  role    = "roles/storage.objectViewer"
  member  = "serviceAccount:${google_service_account.cluster_service_account.email}"
}

resource "google_project_iam_member" "cluster_service_account_artifact_registry" {
  count   = var.grant_registry_access ? 1 : 0
  project = var.project_id
  role    = "roles/artifactregistry.reader"
  member  = "serviceAccount:${google_service_account.cluster_service_account.email}"
}