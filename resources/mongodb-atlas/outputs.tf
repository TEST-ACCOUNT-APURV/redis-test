output "connection" {
  value     = mongodbatlas_cluster.cluster.connection_strings
  sensitive = true
}