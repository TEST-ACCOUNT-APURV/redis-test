output "host" {
  value = google_redis_instance.memorystore.host
}

output "port" {
  value = google_redis_instance.memorystore.port
}

output "user" {
  value     = ""
  sensitive = true
}

output "password" {
  value     = google_redis_instance.memorystore.auth_string
  sensitive = true
}