resource "random_string" "cloudsql_database_name" {
  length  = 10
  special = false
  lower   = true
  upper   = false
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/sql_database_instance
data "google_sql_database_instance" "instance" {
  name = var.instance_name
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/sql_database
resource "google_sql_database" "database" {
  name     = "database-${random_string.cloudsql_database_name.result}"
  instance = var.instance_name
}