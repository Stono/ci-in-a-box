resource "google_sql_database_instance" "mysql" {
  name = "${var.stack_name}-${var.env}-sql"
  region = "${var.target_region}"
  database_version = "MYSQL_5_7"

  settings {
    tier = "db-n1-standard-1"
    activation_policy = "ALWAYS"
    disk_autoresize = "true"
    disk_size = "10"
    disk_type = "PD_SSD"
    location_preference  = {
      zone = "${var.target_zone_a}"
    }
    ip_configuration = {
      ipv4_enabled = "true"
      authorized_networks = [
        {
          name = "local"
          value = "127.0.0.1"
        }
      ]
      require_ssl = "false"
    }
    database_flags = [
      { 
        name = "sql_mode" 
        value = "TRADITIONAL"
      }
    ]
    backup_configuration = {
      enabled = "true"
    }
  }
}

resource "google_sql_user" "users" {
  name     = "sqluser"
  instance = "${google_sql_database_instance.mysql.name}"
  host     = "%"
  password = "${var.mysql_password}"
}
