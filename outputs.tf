output "cluster_name" {
  value = google_container_cluster.this.name
}
output "endpoint" {
  value = google_container_cluster.this.endpoint
}
output "ca_certificate" {
  value = base64decode(google_container_cluster.this.master_auth.0.cluster_ca_certificate)
}
output "kubernetes_version" {
  value = split("-", google_container_cluster.this.master_version)[0]
}
