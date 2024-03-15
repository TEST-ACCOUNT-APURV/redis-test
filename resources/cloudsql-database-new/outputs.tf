output "host" {
  value = data.google_sql_database_instance.instance.private_ip_address
}

output "port" {
  value = var.port
}

output "username" {
  value     = var.username
  sensitive = true
}

output "password" {
  value     = var.password
  sensitive = true
}

output "name" {
  value     = google_sql_database.database.name
}
