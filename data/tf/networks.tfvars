network1 = {
  name = "tf-network10"
  cidr = "10.20.10.0/24"
  bridge = "virbr21"
  type = "none"
}

network2 = {
  name = "tf-network20"
  cidr = "10.20.20.0/24"
  bridge = "virbr22"
  type = "none"
}

network3 = {
  name = "tf-network30"
  cidr = "10.20.30.0/24"
  bridge = "virbr23"
  type = "none"
}

network4 = {
  name = "tf-network40"
  cidr = "10.20.40.0/24"
  bridge = "virbr24"
  type = "none"
}

network-ext = {
  name = "tf-network-ext"
  type = "bridge"
  bridge = "br0"
}
