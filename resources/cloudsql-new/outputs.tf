output "instance" {
  value = google_sql_database_instance.instance.name
}

output "host" {
  value = var.private_ip ? data.google_sql_database_instance.instance.private_ip_address : data.google_sql_database_instance.instance.public_ip_address
}

output "port" {
  value = var.port
}

output "username" {
  value     = google_sql_user.user.name
  sensitive = true
}

output "password" {
  value     = google_sql_user.user.password
  sensitive = true
}

output "name" {
  value = google_sql_database.database.name
}