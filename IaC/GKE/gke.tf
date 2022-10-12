
resource "random_string" "password" {
  length  = 4
  upper   = false
  special = false
}

provider "random" {
}

provider "google" {
  credentials = file(var.credentials)
  project     = var.project
  region      = var.region
  zone        = "${var.region}-c"
}


data "google_container_engine_versions" "gke-kube-version" {
  location       = "${var.region}-c" #conversation regional cluster to zonal cluster
  version_prefix = "${var.kube_version}."
}


resource "google_container_cluster" "cluster" {
  name     = "${var.prefix}-${random_string.password.result}"
  location = "${var.region}-c" #conversation regional cluster to zonal cluster
  # must be same or less than min_master_version


  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  #remove_default_node_pool = true
  initial_node_count = var.node_count
  node_config {
    machine_type = var.general_purpose_machine_type

    metadata = {
      disable-legacy-endpoints = "true"
    }
    # Needed for correctly functioning cluster, see
    # https://www.terraform.io/docs/providers/google/r/container_cluster.html#oauth_scopes
    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/devstorage.read_only"
    ]
  }


  # Setting an empty username and password explicitly disables basic auth
  master_auth {
    client_certificate_config {
      issue_client_certificate = false
    }
  }


  # A set of options for creating a private cluster.
  private_cluster_config {
    # Whether the master's internal IP address is used as the cluster endpoint.
    # GCP Console checkbox enablement:  Access master using its external IP address
    enable_private_endpoint = false

    # Whether nodes have internal IP addresses only. If enabled, all nodes are
    # given only RFC 1918 private addresses and communicate with the master via
    # private networking.
    enable_private_nodes = true

    master_ipv4_cidr_block = var.master_ipv4_cidr_block
  }

  network_policy {
    enabled  = "true"
    provider = "CALICO"
  }

  addons_config {
    # Whether we should enable the network policy addon for the master. This must be
    # enabled in order to enable network policy for the nodes. It can only be disabled
    # if the nodes already do not have network policies enabled. Defaults to disabled;
    # set disabled = false to enable.
    network_policy_config {
      disabled = false
    }
  }

  # The desired configuration options for master authorized networks. Omit the
  # nested cidr_blocks attribute to disallow external access (except the
  # cluster node IPs, which GKE automatically whitelists).
  master_authorized_networks_config {
    cidr_blocks {
      cidr_block   = "199.167.55.50/32"
      display_name = "HQ1"
    }
    cidr_blocks {
      cidr_block   = "209.37.97.14/32"
      display_name = "HQ2"
    }
    cidr_blocks {
      cidr_block   = "8.47.64.2/32"
      display_name = "HQ3"
    }
    cidr_blocks {
      cidr_block   = "199.167.54.229/32"
      display_name = "HQ4"
    }
    cidr_blocks {
      cidr_block   = "199.167.52.5/32"
      display_name = "HQ5"
    }
    cidr_blocks {
      cidr_block   = "13.52.38.137/32"
      display_name = "HQ6"
    }
    cidr_blocks {
      cidr_block   = var.corp_public_ip
      display_name = "Home-IP"
    }

  }




  #master_authorized_networks_config {
  #  dynamic "cidr_blocks" {
  #    for_each = var.master_authorized_networks_cidr_blocks
  #    content {
  #      cidr_block   = cidr_blocks.value.cidr_block
  #      display_name = cidr_blocks.value.name
  #    }
  #  }
  #}




  # Configuration for cluster IP allocation. As of now, only pre-allocated
  # subnetworks (custom type with secondary ranges) are supported. This will
  # activate IP aliases.
  ip_allocation_policy {
    # Whether alias IPs will be used for pod IPs in the cluster. Defaults to
    # true if the ip_allocation_policy block is defined, and to the API
    # default otherwise. Prior to June 17th 2019, the default on the API is
    # false; afterwards, it's true.
    #use_ip_aliases = true

    cluster_ipv4_cidr_block  = var.pod_ipv4_cidr_block # no of pods = 1024
    services_ipv4_cidr_block = var.svc_ipv4_cidr_block # no of services 256


  }

  network    = var.create_requirements ? google_compute_network.vpc[0].name : var.vpc_network_name
  subnetwork = var.create_requirements ? google_compute_subnetwork.subnet[0].name : var.vpc_subnetwork_name

  # add labels
}


#resource "google_container_node_pool" "general_purpose" {
#  name       = "demo-pc-github-nodepool-${random_string.password.result}"
#  location   = "${var.region}-a"
#  cluster    = "${google_container_cluster.cluster.name}"
#
#  management {
#    auto_repair = "false"
#    auto_upgrade = "false"
#  }
#
#  initial_node_count = "${var.node_count}"
#
#  node_config {
#    machine_type = "${var.general_purpose_machine_type}"
#
#    metadata = {
#      disable-legacy-endpoints = "true"
#    }
#    # Needed for correctly functioning cluster, see
#    # https://www.terraform.io/docs/providers/google/r/container_cluster.html#oauth_scopes
#    oauth_scopes = [
#      "https://www.googleapis.com/auth/logging.write",
#      "https://www.googleapis.com/auth/monitoring",
#      "https://www.googleapis.com/auth/devstorage.read_only"
#    ]
#  }
#}



# The following outputs allow authentication and connectivity to the GKE Cluster
# by using certificate-based authentication.

# ****** Enable if need be ********
#output "client_certificate" {
#  value = "${google_container_cluster.cluster.master_auth.0.client_certificate}"
#}
#
#output "client_key" {
#  value = "${google_container_cluster.cluster.master_auth.0.client_key}"
#}
#
#output "cluster_ca_certificate" {
#  value = "${google_container_cluster.cluster.master_auth.0.cluster_ca_certificate}"
#}
#
#output "cluster_instance_group_urls" {
#  value = "${google_container_cluster.cluster.instance_group_urls}"
#}
#output "cluster_kube_node_config" {
#        value = "${google_container_cluster.cluster.node_config}"
#}
#
#output "cluster_kube_node_pool" {
#        value = "${google_container_cluster.cluster.node_pool}"
#}


output "cluster_version" {
  value = google_container_cluster.cluster.master_version
}


output "cluster_region" {
  value = google_container_cluster.cluster.location
}

output "project" {
  value = var.project
}

output "cluster_name" {
  value = "${var.prefix}-${random_string.password.result}"
}

output "default_supported_cluster_kube_version" {
  value = data.google_container_engine_versions.gke-kube-version.default_cluster_version
}

output "cluster_kube_endpoint" {
  value = google_container_cluster.cluster.endpoint
}

output "cluster_kube_servcies_ipv4_cidr" {
  value = google_container_cluster.cluster.services_ipv4_cidr
}


