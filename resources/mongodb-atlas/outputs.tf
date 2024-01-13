output "connection" {
  value     = mongodbatlas_cluster.cluster.connection_strings[0].standard
  sensitive = true
}