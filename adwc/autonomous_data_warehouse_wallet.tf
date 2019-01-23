resource "random_string" "wallet_password" {
  length  = 16
  special = true
}

data "oci_database_autonomous_data_warehouse_wallet" "autonomous_data_warehouse_wallet" {
  #Required
  autonomous_data_warehouse_id = "${oci_database_autonomous_data_warehouse.autonomous_data_warehouse.id}"
  password                     = "${oci_database_autonomous_data_warehouse.autonomous_data_warehouse.admin_password}"
}

resource "local_file" "autonomous_data_warehouse_wallet_file" {
  content  = "${data.oci_database_autonomous_data_warehouse_wallet.autonomous_data_warehouse_wallet.content}"
  filename = "${var.wallet_path}/autonomous_data_warehouse_wallet.zip"
}

output "wallet_password" {
  value = ["${random_string.wallet_password.result}"]
}
