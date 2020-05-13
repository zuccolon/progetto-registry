// CONFIGURAZIONE PROVIDER
provider "google" {
  credentials = file("key.json")
  project     = "dockerbox-277106"
  region      = "us-west1"
}

// CREAZIONE DEL NETWORK
resource "google_compute_network" "vpc_network" {
  name = "gitlab-network"
}

// CREAZIONE IP PUBBLICO STATICO
resource "google_compute_address" "ip_address" {
  name = "gitlab-address"
}

// IMPOSTAZIONE DEL FIREWALL
resource "google_compute_firewall" "default" {
  name    = "gitlab-app-firewall"
  network = "${google_compute_network.vpc_network.id}"
  allow {
    protocol = "tcp"
    ports    = ["80","443","22","5050","8080"]
  }
}

// GENERATORE DI NUMERI RANDOM
resource "random_id" "instance_id" {
  byte_length = 2
}

// CREAZIONE DELLA ISTANZA O VM
resource "google_compute_instance" "default" {
  name         = "gitlab-vm-${random_id.instance_id.hex}"
  machine_type = "n1-standard-4"
  zone         = "us-west1-b"
  boot_disk {
    initialize_params {
      image = "ubuntu-1804-lts"
      size  = 64
    }
  }
  metadata = {
    ssh-keys = "niccolo.zuccolo:${file("~/.ssh/id_ed25519.pub")}"
    startup-script = "${file("scripts/bootstrap.sh")}"
  }
  network_interface {
    network = "${google_compute_network.vpc_network.id}"
    access_config {
      nat_ip = "${google_compute_address.ip_address.address}"
    }
  }
}

// STAMPA DELL'INDIRIZZO IP
output "instance_details" {
  value = "${google_compute_instance.default}"
}

// HEALTH CHECK TCP
resource "google_compute_health_check" "tcp-health-check" {
  name        = "tcp-health-check"
  description = "Health check via tcp"

  timeout_sec         = 1
  check_interval_sec  = 1
  healthy_threshold   = 4
  unhealthy_threshold = 5

  tcp_health_check {
    port_name          = "health-check-port"
    port_specification = "USE_NAMED_PORT"
    request            = "ARE YOU HEALTHY?"
    proxy_header       = "NONE"
    response           = "I AM HEALTHY"
  }
}
