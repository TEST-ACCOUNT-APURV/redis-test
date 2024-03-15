resource "random_string" "cloudsql_instance_name" {
  length  = 10
  special = false
  lower   = true
  upper   = false
}

resource "random_string" "cloudsql_database_name" {
  length  = 10
  special = false
  lower   = true
  upper   = false
}

resource "random_string" "cloudsql_user_name" {
  length  = 10
  special = false
  lower   = true
  upper   = false
}

resource "random_string" "cloudsql_user_password" {
  length  = 10
  special = true
  lower   = true
  upper   = true
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/sql_database_instance
resource "google_sql_database_instance" "instance" {
  name                = "instance-${random_string.cloudsql_instance_name.result}"
  database_version    = var.database_version
  region              = var.location
  deletion_protection = var.instance_deletion_protection

  settings {
    tier = var.tier

    ip_configuration {
      ipv4_enabled                                  = false
      private_network                               = var.private_network
      enable_private_path_for_google_cloud_services = false
    }
  }
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/sql_database
resource "google_sql_database" "database" {
  name     = "database-${random_string.cloudsql_database_name.result}"
  instance = google_sql_database_instance.instance.name
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/sql_user
resource "google_sql_user" "user" {
  name     = random_string.cloudsql_user_name.result
  instance = google_sql_database_instance.instance.name
  password = random_string.cloudsql_user_password.result
}