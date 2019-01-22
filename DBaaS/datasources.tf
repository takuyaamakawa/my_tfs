# Gets a list of Availability Domains
data "oci_identity_availability_domains" "ADs" {
    compartment_id = "${var.tenancy_ocid}"
}

data "oci_core_subnet" "test01Sn01"{
    subnet_id = "${var.subnet_id}"
}
