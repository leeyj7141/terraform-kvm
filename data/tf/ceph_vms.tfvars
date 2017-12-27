vm_ceph_mon_name = "ceph-mon"
vm_ceph_mon_names = [
  "ceph-mon01",
  "ceph-mon02",
  "ceph-mon03"
]

vm_ceph_mon_type = {
  cpu = "2"
  memory = "8192"
  root_disk_size = "40"
}

vm_ceph_mon_ip_addresses = [
  "10.10.10.31",
  "10.10.10.32",
  "10.10.10.33"
]

vm_ceph_mon_mac_addresses = [
  "32:87:02:43:df:c1",
  "32:87:02:43:df:c2",
  "32:87:02:43:df:c3"
]


vm_ceph_osd_name = "ceph-osd"
vm_ceph_osd_names = [
  "ceph-osd01",
  "ceph-osd02",
  "ceph-osd03"
]

vm_ceph_osd_type = {
  cpu = "2"
  memory = "8192"
  root_disk_size = "40"

  # Disk setting for extra volumes to use as osd(size is in G)
  extra_disk_count = "3"
  extra_disk_size = 10
}

vm_ceph_osd_volume_name_fmt = "ceph-osd%02d_%02d.img"

vm_ceph_osd_ip_addresses = [
  "10.10.10.41",
  "10.10.10.42",
  "10.10.10.43",
]

vm_ceph_osd_mac_addresses = [
  "32:87:02:43:df:d1",
  "32:87:02:43:df:d2",
  "32:87:02:43:df:d3"
]