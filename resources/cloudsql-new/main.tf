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
  name             = "instance-${random_string.cloudsql_instance_name.result}"
  database_version = var.database_version
  region           = var.location

  settings {
    tier = var.tier

    ip_configuration {
      dynamic "authorized_networks" {
        for_each = var.authorized_networks
        content {
          value = authorized_networks.value
        }
      }
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