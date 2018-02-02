#kvm_provider_url = "qemu+ssh://root@192.168.18.3/system"
kvm_provider_url = "qemu+ssh://root@127.0.0.1/system"

cloud_image_dir = "../images"
cloud_image_file = "CentOS-7-x86_64-GenericCloud-1611.qcow2"

vm_vol_pool_dir = "/home/VMs-path"
vm_vol_pool_name = "VMs-pool"

#vm_pub_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDHy3RKNEJUJqyqVCllb2Ph6/a5r7j//VJze4VZXWvuRrpDtUCJzz/HtZYq9F06IOwPDwblruelhxSotxd1gdZDBuP1u+9zjoP8t8aTvLPDsyoy2lDnp2AsuhJTE1v0YGIVt3ydmoknTb+8jMj8bY4CuaOj1Y8WJtMKYSgP6uzj6tSPDCquGp3+5t7MP8G2acwKvLyNK6a85MZv60gIjn2R/z/hK2bOj1xB77PUWZw6Dbjhf9BUOHFKqVDD2nkYYIA7RJLuKjG1sS5u8mkEuv5LBEzpV4JswqyPfDAJKcr4kFrv1IZ/8EpdMvY9MdBOIsaWkg47QxaZpGsZGHJy+Wx/ root@jyy-openstack"
vm_pub_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC89+KTru1TdaKbrSBdTSJMIdW0wHL6lXHwvNkk1W77ofr/Ys/qI7PBz56IBUOMKhk/Gy1z02RqsG4i4SLH6+Oq5GZOGXG4dNhfQcfKq9ouTyJ2fwqBr/49MB+kAxyZkCFrjffPe/VWVPYQHxT5SItqLX7e4gLRNFUNR2el1vkOyk4b20PiVZQpJS4R6CuQ0mktwKsMqEu/lb9weIqgRFn9gw4GyWXnA5cSFGting5dbXUvrrlpDIXZ9WDJFKzONbdgw7AuxUF0DPLyj5STMjgZTAhANlUbdkorxwAMJx5Al6KGtypwdzgEndXD2Z9CdEsV7ZZLfnEhpIw7JArzxo2F root@cloud-test02.osci.kr"
vm_user_data = "#cloud-config\npassword: password\nchpasswd: { expire: False }\nssh_pwauth: True"
