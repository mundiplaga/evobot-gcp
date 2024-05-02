terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
    }
  }
}

provider "google" {
  project = var.GCP_PROJECT
}

resource "google_project_service" "compute_api" {
  service                    = "compute.googleapis.com"
  disable_dependent_services = true
}

resource "google_compute_disk" "default" {
  depends_on = [google_project_service.compute_api]
  image                     = "projects/cos-cloud/global/images/cos-109-17800-218-14"
  name                      = "boot"
  physical_block_size_bytes = 4096
  size                      = 10
  type                      = "pd-standard"
  zone                      = var.GCP_ZONE
}

resource "google_compute_network" "vpc_network" {
  depends_on              = [google_project_service.compute_api]
  name                    = "evobot"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnet" {
  depends_on    = [google_project_service.compute_api]
  name          = "evobot"
  ip_cidr_range = "10.2.0.0/24"
  region        = var.GCP_REGION
  network       = google_compute_network.vpc_network.id
}

resource "google_compute_instance" "default" {
  depends_on          = [google_project_service.compute_api]
  can_ip_forward      = false
  deletion_protection = false
  enable_display      = false
  guest_accelerator   = []
  machine_type        = "e2-micro"
  name                = "evobot"
  resource_policies   = []
  tags = [
    "http-server",
    "https-server",
  ]
  zone = var.GCP_ZONE
  metadata = {
    "gce-container-declaration" = <<-EOT
            spec:
              restartPolicy: Always
              containers:
              - name: evobot
                image: eritislami/evobot
                env:
                - name: TOKEN
                  value: ${var.DISCORD_TOKEN}
        EOT
    "google-logging-enabled"    = "true"
    "google-monitoring-enabled" = "true"
  }

  boot_disk {
    auto_delete = true
    device_name = "evobot"
    mode        = "READ_WRITE"
    source      = google_compute_disk.default.self_link
  }

  network_interface {
    internal_ipv6_prefix_length = 0
    ipv6_access_type            = null
    ipv6_address                = null
    network                     = google_compute_network.vpc_network.self_link
    network_ip                  = "10.2.0.2"
    nic_type                    = null
    queue_count                 = 0
    stack_type                  = "IPV4_ONLY"
    subnetwork                  = google_compute_subnetwork.subnet.self_link
    subnetwork_project          = var.GCP_PROJECT
    access_config {
      network_tier = "STANDARD"
    }
  }

  scheduling {
    automatic_restart           = true
    instance_termination_action = null
    min_node_cpus               = 0
    on_host_maintenance         = "MIGRATE"
    preemptible                 = false
    provisioning_model          = "STANDARD"
  }
}