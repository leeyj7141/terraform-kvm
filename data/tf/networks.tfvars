network1 = {
  name = "network-10"
  cidr = "10.10.10.0/24"
  bridge = "virbr1"
  type = "none"
}

network2 = {
  name = "network-20"
  cidr = "10.10.20.0/24"
  bridge = "virbr2"
  type = "none"
}

network3 = {
  name = "network-30"
  cidr = "10.10.30.0/24"
  bridge = "virbr3"
  type = "none"
}

network4 = {
  name = "network-40"
  cidr = "10.10.40.0/24"
  bridge = "virbr4"
  type = "none"
}

network-ext = {
  name = "network-ext"
  type = "bridge"
  bridge = "br0"
}
