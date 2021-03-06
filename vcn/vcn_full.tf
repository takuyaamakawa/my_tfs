variable "VPC-CIDR" {
  default = "10.0.0.0/16"
}

data "oci_identity_availability_domains" "ADs" {
  compartment_id = "${var.tenancy_ocid}"
}

resource "oci_core_virtual_network" "test01VCN" {
  cidr_block     = "${var.VPC-CIDR}"
  compartment_id = "${var.compartment_ocid}"
  display_name   = "test01VCN"
}

resource "oci_core_internet_gateway" "test01IG" {
  compartment_id = "${var.compartment_ocid}"
  display_name   = "test01IG"
  vcn_id         = "${oci_core_virtual_network.test01VCN.id}"
}

resource "oci_core_route_table" "RouteFortest01" {
  compartment_id = "${var.compartment_ocid}"
  vcn_id         = "${oci_core_virtual_network.test01VCN.id}"
  display_name   = "RouteTableFortest01"

  route_rules {
    cidr_block        = "0.0.0.0/0"
    network_entity_id = "${oci_core_internet_gateway.test01IG.id}"
  }
}

resource "oci_core_security_list" "WebSubnet" {
  compartment_id = "${var.compartment_ocid}"
  display_name   = "Public"
  vcn_id         = "${oci_core_virtual_network.test01VCN.id}"

  egress_security_rules = [{
    destination = "0.0.0.0/0"
    protocol    = "6"
  }]

  ingress_security_rules = [{
    tcp_options {
      "max" = 80
      "min" = 80
    }

    protocol = "6"
    source   = "0.0.0.0/0"
  },
    {
      protocol = "6"
      source   = "${var.VPC-CIDR}"
    },
  ]
}

resource "oci_core_security_list" "PrivateSubnet" {
  compartment_id = "${var.compartment_ocid}"
  display_name   = "Private"
  vcn_id         = "${oci_core_virtual_network.test01VCN.id}"

  egress_security_rules = [{
    protocol    = "6"
    destination = "${var.VPC-CIDR}"
  }]

  ingress_security_rules = [{
    protocol = "6"
    source   = "${var.VPC-CIDR}"
  }]
}

resource "oci_core_security_list" "BastionSubnet" {
  compartment_id = "${var.compartment_ocid}"
  display_name   = "Bastion"
  vcn_id         = "${oci_core_virtual_network.test01VCN.id}"

  egress_security_rules = [{
    protocol    = "6"
    destination = "0.0.0.0/0"
  }]

  ingress_security_rules = [{
    tcp_options {
      "max" = 22
      "min" = 22
    }

    protocol = "6"
    source   = "0.0.0.0/0"
  },
    {
      protocol = "6"
      source   = "${var.VPC-CIDR}"
    },
  ]
}

resource "oci_core_subnet" "WebSubnetAD1" {
  availability_domain = "${lookup(data.oci_identity_availability_domains.ADs.availability_domains[0],"name")}"
  cidr_block          = "10.0.1.0/24"
  display_name        = "WebSubnetAD1"
  compartment_id      = "${var.compartment_ocid}"
  vcn_id              = "${oci_core_virtual_network.test01VCN.id}"
  route_table_id      = "${oci_core_route_table.RouteFortest01.id}"
  security_list_ids   = ["${oci_core_security_list.WebSubnet.id}"]
  dhcp_options_id     = "${oci_core_virtual_network.test01VCN.default_dhcp_options_id}"
}

resource "oci_core_subnet" "WebSubnetAD2" {
  availability_domain = "${lookup(data.oci_identity_availability_domains.ADs.availability_domains[1],"name")}"
  cidr_block          = "10.0.2.0/24"
  display_name        = "WebSubnetAD2"
  compartment_id      = "${var.compartment_ocid}"
  vcn_id              = "${oci_core_virtual_network.test01VCN.id}"
  route_table_id      = "${oci_core_route_table.RouteFortest01.id}"
  security_list_ids   = ["${oci_core_security_list.WebSubnet.id}"]
  dhcp_options_id     = "${oci_core_virtual_network.test01VCN.default_dhcp_options_id}"
}

resource "oci_core_subnet" "WebSubnetAD3" {
  availability_domain = "${lookup(data.oci_identity_availability_domains.ADs.availability_domains[2],"name")}"
  cidr_block          = "10.0.3.0/24"
  display_name        = "WebSubnetAD3"
  compartment_id      = "${var.compartment_ocid}"
  vcn_id              = "${oci_core_virtual_network.test01VCN.id}"
  route_table_id      = "${oci_core_route_table.RouteFortest01.id}"
  security_list_ids   = ["${oci_core_security_list.WebSubnet.id}"]
  dhcp_options_id     = "${oci_core_virtual_network.test01VCN.default_dhcp_options_id}"
}

resource "oci_core_subnet" "PrivateSubnetAD1" {
  availability_domain        = "${lookup(data.oci_identity_availability_domains.ADs.availability_domains[0],"name")}"
  cidr_block                 = "10.0.4.0/24"
  display_name               = "PrivateSubnetAD1"
  compartment_id             = "${var.compartment_ocid}"
  vcn_id                     = "${oci_core_virtual_network.test01VCN.id}"
  route_table_id             = "${oci_core_route_table.RouteFortest01.id}"
  security_list_ids          = ["${oci_core_security_list.PrivateSubnet.id}"]
  dhcp_options_id            = "${oci_core_virtual_network.test01VCN.default_dhcp_options_id}"
  prohibit_public_ip_on_vnic = "true"
}

resource "oci_core_subnet" "PrivateSubnetAD2" {
  availability_domain        = "${lookup(data.oci_identity_availability_domains.ADs.availability_domains[1],"name")}"
  cidr_block                 = "10.0.5.0/24"
  display_name               = "PrivateSubnetAD2"
  compartment_id             = "${var.compartment_ocid}"
  vcn_id                     = "${oci_core_virtual_network.test01VCN.id}"
  route_table_id             = "${oci_core_route_table.RouteFortest01.id}"
  security_list_ids          = ["${oci_core_security_list.PrivateSubnet.id}"]
  dhcp_options_id            = "${oci_core_virtual_network.test01VCN.default_dhcp_options_id}"
  prohibit_public_ip_on_vnic = "true"
}

resource "oci_core_subnet" "PrivateSubnetAD3" {
  availability_domain        = "${lookup(data.oci_identity_availability_domains.ADs.availability_domains[2],"name")}"
  cidr_block                 = "10.0.6.0/24"
  display_name               = "PrivateSubnetAD3"
  compartment_id             = "${var.compartment_ocid}"
  vcn_id                     = "${oci_core_virtual_network.test01VCN.id}"
  route_table_id             = "${oci_core_route_table.RouteFortest01.id}"
  security_list_ids          = ["${oci_core_security_list.PrivateSubnet.id}"]
  dhcp_options_id            = "${oci_core_virtual_network.test01VCN.default_dhcp_options_id}"
  prohibit_public_ip_on_vnic = "true"
}

resource "oci_core_subnet" "BastionSubnetAD1" {
  availability_domain = "${lookup(data.oci_identity_availability_domains.ADs.availability_domains[0],"name")}"
  cidr_block          = "10.0.7.0/24"
  display_name        = "BastionSubnetAD1"
  compartment_id      = "${var.compartment_ocid}"
  vcn_id              = "${oci_core_virtual_network.test01VCN.id}"
  route_table_id      = "${oci_core_route_table.RouteFortest01.id}"
  security_list_ids   = ["${oci_core_security_list.BastionSubnet.id}"]
  dhcp_options_id     = "${oci_core_virtual_network.test01VCN.default_dhcp_options_id}"
}

resource "oci_core_subnet" "BastionSubnetAD2" {
  availability_domain = "${lookup(data.oci_identity_availability_domains.ADs.availability_domains[1],"name")}"
  cidr_block          = "10.0.8.0/24"
  display_name        = "BastionSubnetAD2"
  compartment_id      = "${var.compartment_ocid}"
  vcn_id              = "${oci_core_virtual_network.test01VCN.id}"
  route_table_id      = "${oci_core_route_table.RouteFortest01.id}"
  security_list_ids   = ["${oci_core_security_list.BastionSubnet.id}"]
  dhcp_options_id     = "${oci_core_virtual_network.test01VCN.default_dhcp_options_id}"
}

resource "oci_core_subnet" "BastionSubnetAD3" {
  availability_domain = "${lookup(data.oci_identity_availability_domains.ADs.availability_domains[2],"name")}"
  cidr_block          = "10.0.9.0/24"
  display_name        = "BastionSubnetAD3"
  compartment_id      = "${var.compartment_ocid}"
  vcn_id              = "${oci_core_virtual_network.test01VCN.id}"
  route_table_id      = "${oci_core_route_table.RouteFortest01.id}"
  security_list_ids   = ["${oci_core_security_list.BastionSubnet.id}"]
  dhcp_options_id     = "${oci_core_virtual_network.test01VCN.default_dhcp_options_id}"
}
