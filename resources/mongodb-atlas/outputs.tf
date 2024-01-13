output "connection" {
  value     = replace(mongodbatlas_cluster.cluster.connection_strings[0].standard_srv, "mongodb+srv://", format("mongodb+srv://%s:%s@%s", mongodbatlas_database_user.user.username, mongodbatlas_database_user.user.password, trimprefix(mongodbatlas_cluster.cluster.connection_strings[0].standard_srv, "mongodb+srv://")))
  sensitive = true
}