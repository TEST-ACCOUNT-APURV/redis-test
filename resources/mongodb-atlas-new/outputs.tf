output "connection" {
  value     = replace(mongodbatlas_cluster.cluster.connection_strings[0].standard_srv, "mongodb+srv://", format("mongodb+srv://%s:%s@", urlencode(mongodbatlas_database_user.user.username), urlencode(nonsensitive(mongodbatlas_database_user.user.password))))
  sensitive = true
}