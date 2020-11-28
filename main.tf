 
resource "random_id" "instance_id" {
  byte_length = 8
}

resource "google_compute_instance" "default" {
  name         = "vm-${random_id.instance_id.hex}"
  machine_type = "f1-micro"
  zone         = "us-west1-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }


  metadata_startup_script = "sudo apt-get update && sudo apt-get install -y software-properties-common && curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash - && sudo apt-get install -y nodejs && sudo apt-get install -y git && sudo apt-get install -y helm && sudo apt-get install -y openjdk-8-jdk && sudo apt-get install -y kubectl && sudo apt-get install -y unzip && wget https://releases.hashicorp.com/terraform/0.12.18/terraform_0.12.18_linux_amd64.zip && unzip terraform_0.12.18_linux_amd64.zip && sudo mv terraform /usr/local/bin/ && sudo apt-get install apache2 -y && echo '<!doctype html><html><body><h1>Hello from Terraform on Google Cloud!</h1></body></html>' | sudo tee /var/www/html/index.html && sudo apt install -y apt-transport-https ca-certificates curl software-properties-common gnupg2 && curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add - && sudo apt-get update && sudo add-apt-repository 'deb [arch=amd64] https://download.docker.com/linux/ubuntu/ bionic stable' && curl -O https://download.docker.com/linux/ubuntu/dists/bionic/pool/edge/amd64/containerd.io_1.2.2-3_amd64.deb && sudo apt install -y ./containerd.io_1.2.2-3_amd64.deb && sudo apt-get update && sudo apt install -y docker-ce"

  network_interface {
    network = "default"

    access_config {
      // Include this section to give the VM an external ip address
    }
  }

  // Apply the firewall rule to allow external IPs to access this instance
  tags = ["http-server"]
}

resource "google_compute_firewall" "http-server" {
  name    = "default-allow-http"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  // Allow traffic from everywhere to instances with an http-server tag
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["http-server"]
}

output "ip" {
  value = "${google_compute_instance.default.network_interface.0.access_config.0.nat_ip}"
}

