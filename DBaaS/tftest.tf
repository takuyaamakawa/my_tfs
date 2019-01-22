
provider "oci" {
  tenancy_ocid         = "${var.tenancy_ocid}"
  user_ocid            = "${var.user_ocid}"
  fingerprint          = "${var.fingerprint}"
  private_key_path     = "${var.private_key_path}"
  region               = "${var.region}"
  disable_auto_retries = "true"
}

provider "oraclepaas" {
  user              = "${var.paas_user}"
  password          = "${var.paas_password}"
  identity_domain   = "${var.identity_domain}"
  database_endpoint = "${var.database_endpoint}"
}

locals {
  database_server_name = "odics01_db01"
  database_backup_bucket = "${var.object_storage_bucket}"
  AD = 1
  availability_domain = "${lookup(data.oci_identity_availability_domains.ADs.availability_domains[0],"name")}"
  subnet = "${data.oci_core_subnet.test01Sn01.id}"
}

resource "oraclepaas_database_service_instance" "database" {
  count             = 1
  name              = "${local.database_server_name}"
  description       = "Created by Terraform"
  version           = "12.2.0.1"
  edition           = "EE"
  subscription_type = "HOURLY"
  ssh_public_key    = "${join(" ",slice(split(" ",file("~/.ssh/id_rsa.pub")),0,2))}"

  bring_your_own_license = true

  # OCI Settings
  region              = "${var.region}"
  availability_domain = "${local.availability_domain}"
  subnet              = "${local.subnet}"
  shape               = "${var.InstanceShape}"

  database_configuration {
    admin_password     = "OCIhaTokyo1098”"
    backup_destination = "BOTH"
    sid                = "ORCL"
    usable_storage     = 100
  }

  backups {
    cloud_storage_container = "https://swiftobjectstorage.${var.region}.oraclecloud.com/v1/${var.tenancy}/${local.database_backup_bucket}"
    cloud_storage_username  = "${var.object_storage_user}"
    cloud_storage_password  = "${var.swift_password}"
  }
}
output "Cloud Storage Container"{
  value = "${oraclepaas_database_service_instance.database.backups.cloud_storage_container}"
}
