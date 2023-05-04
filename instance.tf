resource "google_compute_instance" "terraform" {
  project      = "my-project-13971-challenge"
  name         = "terraform"
  machine_type = "n1-standard-1"
  zone         = "europe-west1-b"
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }
  network_interface {
    network = "default"
    access_config {
    }
  }
}