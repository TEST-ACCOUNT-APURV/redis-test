output "host" {
  value = google_sql_database_instance.instance.public_ip_address
}

output "port" {
  value = 5432
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
  value     = google_sql_database.database.name
}