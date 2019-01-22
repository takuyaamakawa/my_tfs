variable "tenancy_ocid" {}
variable "user_ocid" {}
variable "fingerprint" {}
variable "private_key_path" {}
variable "region" {}

variable "compartment_ocid" {}
variable "ssh_public_key" {}
variable "ssh_private_key" {}

variable "db_admin_password" {}

variable "subnet_id" {}

# Choose an Availability Domain
variable "availability_domain" {
  default = "1"
}

# DBSystem specific
variable "db_system_shape" {
  default = "VM.Standard2.2"
}

variable "cpu_core_count" {
  default = "2"
}

variable "db_edition" {
  default = "ENTERPRISE_EDITION"
}

variable "db_name" {
  default = "myODIDB"
}

variable "db_version" {
  default = "12.2.0.1"
}

variable "db_home_display_name" {
  default = "DBforODI"
}

variable "db_disk_redundancy" {
  default = "NORMAL"
}

variable "db_system_display_name" {
  default = "DBforODI"
}

variable "hostname" {
  default = "db01forodi01"
}

variable "host_user_name" {
  default = "opc"
}

variable "n_character_set" {
  default = "AL16UTF16"
}

variable "character_set" {
  default = "AL32UTF8"
}

variable "db_workload" {
  default = "OLTP"
}

variable "pdb_name" {
  default = "pdb1"
}

variable "data_storage_size_in_gb" {
  default = "256"
}

variable "license_model" {
  default = "LICENSE_INCLUDED"
}

variable "node_count" {
  default = "1"
}

variable "data_storage_percentage" {
  default = "80"
}
