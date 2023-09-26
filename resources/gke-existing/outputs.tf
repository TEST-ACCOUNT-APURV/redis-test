output "loadbalancer" {
  value = data.google_compute_address.public_ip.address
}

output "project_id" {
  value = var.project_id
}

output "name" {
  value = var.gke_name
}

output "cluster_type" {
  value = "gke"
}

output "zone" {
  value = var.gke_location
}

output "credentials" {
  value = base64decode(google_service_account_key.gke_cluster_access_key.private_key)
  sensitive = true
}
