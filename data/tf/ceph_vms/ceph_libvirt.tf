variable "kvm_provider_url" {}
variable "cloud_image_dir" {}
variable "cloud_image_file" {}

variable "vm_vol_pool_dir" {}
variable "vm_vol_pool_name" {}
variable "vm_pub_key" {}
variable "vm_user_data" {}

variable "network1" {
  type = "map"
}

variable "network2" {
  type = "map"
}

variable "network3" {
  type = "map"
}

variable "network4" {
  type = "map"
}

variable "network-ext" {
  type = "map"
}

variable "vm_ceph_mon_names" {
  type = "list"
}

variable "vm_ceph_mon_type" {
  type = "map"
}

variable "vm_ceph_mon_ip_addresses" {
  type = "list"
}

variable "vm_ceph_mon_mac_addresses" {
  type = "list"
}

variable "vm_ceph_osd_names" {
  type = "list"
}

variable "vm_ceph_osd_type" {
  type = "map"
}

variable "vm_ceph_osd_volume_name_fmt" {}

variable "vm_ceph_osd_ip_addresses" {
  type = "list"
}

variable "vm_ceph_osd_mac_addresses" {
  type = "list"
}

provider "libvirt" {
  uri = "${var.kvm_provider_url}"
}

# ceph_mon VMs
data "template_file" "vm_mon_dhcp_network" {
  count    = "${length(var.vm_ceph_mon_names)}"
  template = "virsh net-update $${network_name} add-last ip-dhcp-host --xml \"<host mac='$${mac_address}' ip='$${ip_address}'/>\" --live --config"

  vars {
    network_name = "${var.network1["name"]}"
    ip_address   = "${element(var.vm_ceph_mon_ip_addresses, count.index)}"
    mac_address  = "${element(var.vm_ceph_mon_mac_addresses, count.index)}"
  }
}

output "network1-output1" {
  value = ["${data.template_file.vm_mon_dhcp_network.*.rendered}"]
}

resource "null_resource" "run_vm_mon_dhcp_network" {
  count    = "${length(var.vm_ceph_mon_names)}"
  provisioner "local-exec" {
    command = "${element(data.template_file.vm_mon_dhcp_network.*.rendered, count.index)}"
  }
}

# centos 7 template image
resource "libvirt_volume" "centos7_image" {
  name   = "centos7_image.qcow2"
  pool   = "${var.vm_vol_pool_name}"
  source = "${var.cloud_image_dir}/${var.cloud_image_file}"
}

# volume from template image
resource "libvirt_volume" "vm_mon_root_volume" {
  count          = "${length(var.vm_ceph_mon_names)}"
  name           = "${element(var.vm_ceph_mon_names, count.index)}_vol.img"
  pool           = "${var.vm_vol_pool_name}"
  base_volume_id = "${libvirt_volume.centos7_image.id}"
}

data "template_file" "vm_resize_mon_root_volume" {
  count    = "${length(var.vm_ceph_mon_names)}"
  template = "qemu-img resize $${volume_path}/$${volume_name} +$${volume_size}G"

  vars {
    volume_path = "${var.vm_vol_pool_dir}"
    volume_name = "${element(var.vm_ceph_mon_names, count.index)}_vol.img"
    volume_size = "${var.vm_ceph_mon_type["root_disk_size"]}"
  }
  depends_on = ["libvirt_volume.vm_mon_root_volume"]
}

resource "null_resource" "run_vm_resize_mon_root_volume" {
  count    = "${length(var.vm_ceph_mon_names)}"
  provisioner "local-exec" {
    command = "${element(data.template_file.vm_resize_mon_root_volume.*.rendered, count.index)}"
  }
}

resource "libvirt_cloudinit" "cloud_init_mon" {
  count              = "${length(var.vm_ceph_mon_names)}"

  name               = "${element(var.vm_ceph_mon_names, count.index)}_cloudinit.iso"
  pool               = "${var.vm_vol_pool_name}"
  local_hostname     = "${element(var.vm_ceph_mon_names, count.index)}"
  user_data          = "${var.vm_user_data}"
  ssh_authorized_key = "${var.vm_pub_key}"
}

# domain to create vms
resource "libvirt_domain" "ceph_mon-vms" {
  count      = "${length(var.vm_ceph_mon_names)}"

  name       = "${element(var.vm_ceph_mon_names, count.index)}"
  vcpu        = "${var.vm_ceph_mon_type["cpu"]}"
  memory     = "${var.vm_ceph_mon_type["memory"]}"

  cpu {
    mode = "host-passthrough"
  }

  network_interface {
    network_name   = "${var.network1["name"]}"
    hostname       = "${element(var.vm_ceph_mon_names, count.index)}"
    addresses      = ["${element(var.vm_ceph_mon_ip_addresses, count.index)}"]
    mac            = "${element(var.vm_ceph_mon_mac_addresses, count.index)}"
    wait_for_lease = 1
  }
  network_interface {
    network_name = "${var.network2["name"]}"
  }
  network_interface {
    network_name = "${var.network3["name"]}"
  }
  network_interface {
    network_name = "${var.network4["name"]}"
  }
  network_interface {
    bridge       = "${var.network-ext["bridge"]}"
  }

  cloudinit = "${element(libvirt_cloudinit.cloud_init_mon.*.id, count.index)}"

  disk {
    volume_id = "${element(libvirt_volume.vm_mon_root_volume.*.id, count.index)}"
    pool      = "${var.vm_vol_pool_name}"
  }
  graphics {
    type        = "spice"
    listen_type = "address"
    autoport    = "yes"
  }
  console {
    type        = "pty"
    target_port = "0"
    target_type = "serial"
  }
}

# ceph_osd VMs
data "template_file" "vm_osd_dhcp_network" {
  count    = "${length(var.vm_ceph_osd_names)}"
  template = "virsh net-update $${network_name} add-last ip-dhcp-host --xml \"<host mac='$${mac_address}' ip='$${ip_address}'/>\" --live --config"

  vars {
    network_name = "${var.network1["name"]}"
    ip_address   = "${element(var.vm_ceph_osd_ip_addresses, count.index)}"
    mac_address  = "${element(var.vm_ceph_osd_mac_addresses, count.index)}"
  }
}

output "network1-output2" {
  value = ["${data.template_file.vm_osd_dhcp_network.*.rendered}"]
}

resource "null_resource" "run_vm_osd_dhcp_network" {
  count    = "${length(var.vm_ceph_osd_names)}"
  provisioner "local-exec" {
    command = "${element(data.template_file.vm_osd_dhcp_network.*.rendered, count.index)}"
  }
}

# volume from template image
resource "libvirt_volume" "vm_osd_root_volume" {
  count          = "${length(var.vm_ceph_osd_names)}"
  name           = "${element(var.vm_ceph_osd_names, count.index)}_vol.img"
  pool           = "${var.vm_vol_pool_name}"
  base_volume_id = "${libvirt_volume.centos7_image.id}"
}

data "template_file" "vm_osd_root_volume" {
  count    = "${length(var.vm_ceph_osd_names)}"
  template = "qemu-img resize $${volume_path}/$${volume_name} +$${volume_size}G"

  vars {
    volume_path = "${var.vm_vol_pool_dir}"
    volume_name = "${element(var.vm_ceph_osd_names, count.index)}_vol.img"
    volume_size = "${var.vm_ceph_osd_type["root_disk_size"]}"
  }
  depends_on = ["libvirt_volume.vm_osd_root_volume"]
}

resource "null_resource" "run_vm_osd_root_volume" {
  count    = "${length(var.vm_ceph_osd_names)}"
  provisioner "local-exec" {
    command = "${element(data.template_file.vm_osd_root_volume.*.rendered, count.index)}"
  }
}

# osd extra volumes
resource "libvirt_volume" "vm_osd_extra_volumes" {
  count          = "${length(var.vm_ceph_osd_names) * var.vm_ceph_osd_type["extra_disk_count"]}"
  name           = "${format(var.vm_ceph_osd_volume_name_fmt, count.index / var.vm_ceph_osd_type["extra_disk_count"] + 1, count.index % var.vm_ceph_osd_type["extra_disk_count"])}"
  pool           = "${var.vm_vol_pool_name}"
  size           = "${var.vm_ceph_osd_type["extra_disk_size"] * 1073741824}"
}

resource "libvirt_cloudinit" "cloud_init_osd" {
  count              = "${length(var.vm_ceph_osd_names)}"

  name               = "${element(var.vm_ceph_osd_names, count.index)}_cloudinit.iso"
  pool               = "${var.vm_vol_pool_name}"
  local_hostname     = "${element(var.vm_ceph_osd_names, count.index)}"
  user_data          = "${var.vm_user_data}"
  ssh_authorized_key = "${var.vm_pub_key}"
}

# domain to create vms
resource "libvirt_domain" "ceph_osd-vms" {
  count      = "${length(var.vm_ceph_osd_names)}"

  name       = "${element(var.vm_ceph_osd_names, count.index)}"
  vcpu        = "${var.vm_ceph_osd_type["cpu"]}"
  memory     = "${var.vm_ceph_osd_type["memory"]}"

  cpu {
    mode = "host-passthrough"
  }

  network_interface {
    network_name   = "${var.network1["name"]}"
    hostname       = "${element(var.vm_ceph_osd_names, count.index)}"
    addresses      = ["${element(var.vm_ceph_osd_ip_addresses, count.index)}"]
    mac            = "${element(var.vm_ceph_osd_mac_addresses, count.index)}"
    wait_for_lease = 1
  }
  network_interface {
    network_name = "${var.network2["name"]}"
  }
  network_interface {
    network_name = "${var.network3["name"]}"
  }
  network_interface {
    network_name = "${var.network4["name"]}"
  }
  network_interface {
    bridge       = "${var.network-ext["bridge"]}"
  }

  cloudinit = "${element(libvirt_cloudinit.cloud_init_osd.*.id, count.index)}"

  disk {
    volume_id = "${element(libvirt_volume.vm_osd_root_volume.*.id, count.index)}"
    pool      = "${var.vm_vol_pool_name}"
  }
  graphics {
    type        = "spice"
    listen_type = "address"
    autoport    = "yes"
  }
  console {
    type        = "pty"
    target_port = "0"
    target_type = "serial"
  }
}
