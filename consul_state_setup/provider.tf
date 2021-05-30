provider "consul" {
  address = "127.0.0.1:8500"
  datacenter = "dc1"
}

resource "consul_keys" "networking" {

  key {
    path = "networking/configuration/"
    value = ""
  }
  key {
    path = "networking/state/"
    value = ""
  }
}


resource "consul_keys" "applications" {

  key {
    path = "applications/configuration/"
    value = ""
  }

  key {
    path = "applications/state/"
    value = ""
  }
}

resource "consul_acl_policy" "networking" {
  name = "networking"
  rules = <<-RULE
    key_prefix "networking" {
      policy = "write"
    }
    session_prefix "" {
      policy = "write"
    }
    RULE
}

resource "consul_acl_policy" "applications" {
  name = "applications"
  rules = <<-RULE
    key_prefix "applications" {
      policy = "write"
    }
    key_prefix "networking/state" {
      policy = "read"
    }
    session_prefix "" {
      policy = "write"
    }
    RULE
}

resource "consul_acl_token" "gary" {
  description = "token for gary"
  policies = [consul_acl_policy.networking.name]
}

resource "consul_acl_token" "developer" {
  description = "developer token"
  policies = [consul_acl_policy.applications.name]
}
