resource "packet_device" "fcs" {

  depends_on       = ["packet_ssh_key.host_key"]

  project_id       = "${var.packet_project_id}"
  facilities       = "${var.facilities}"
  plan             = "${var.plan}"
  operating_system = "${var.operating_system}"
  hostname         = "${format("fcs-%02d", count.index)}"

  count            = "${var.fcs_count}"

  billing_cycle    = "hourly"
  tags             = ["${var.build}","fcs"]

  connection {
    user        = "root"
    private_key = "${file("${var.private_key_filename}")}"
  }

  provisioner "file" {
    source      = "consul_install.sh"
    destination = "consul_install.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "ssh-keygen -A",
      "apt-get install fortune -y",
      "bash consul_install.sh > consul_install.out",
    ]
  }
}

