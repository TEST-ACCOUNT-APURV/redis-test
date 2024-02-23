output "host" {
  value = data.google_sql_database_instance.instance.private_ip_address
}

output "port" {
  value = 5432
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
