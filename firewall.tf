resource "google_compute_firewall" "allow_k8s_nodeport" {
  name    = "${var.cluster_name}-allow-k8s-nodeport"
  network = var.network_name

  allow {
    protocol = "tcp"
    ports    = ["30000-32767"]
  }

  source_ranges = ["0.0.0.0/0"]
}
