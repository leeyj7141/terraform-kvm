kvm_provider_url = "qemu+ssh://root@192.168.18.3/system"

cloud_image_dir = "../images"
cloud_image_file = "CentOS-7-x86_64-GenericCloud-1611.qcow2"

vm_vol_pool_dir = "/home/VMs-path"
vm_vol_pool_name = "VMs-pool"

vm_pub_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDHy3RKNEJUJqyqVCllb2Ph6/a5r7j//VJze4VZXWvuRrpDtUCJzz/HtZYq9F06IOwPDwblruelhxSotxd1gdZDBuP1u+9zjoP8t8aTvLPDsyoy2lDnp2AsuhJTE1v0YGIVt3ydmoknTb+8jMj8bY4CuaOj1Y8WJtMKYSgP6uzj6tSPDCquGp3+5t7MP8G2acwKvLyNK6a85MZv60gIjn2R/z/hK2bOj1xB77PUWZw6Dbjhf9BUOHFKqVDD2nkYYIA7RJLuKjG1sS5u8mkEuv5LBEzpV4JswqyPfDAJKcr4kFrv1IZ/8EpdMvY9MdBOIsaWkg47QxaZpGsZGHJy+Wx/ root@jyy-openstack"
vm_user_data = "#cloud-config\npassword: password\nchpasswd: { expire: False }\nssh_pwauth: True"
