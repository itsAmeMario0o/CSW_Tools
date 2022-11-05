terraform {
  required_providers {
    tetration = {
      source = "CiscoDevNet/tetration"
      version = "0.1.1"
    }
  }
}

provider "tetration" {
  api_key                  = "2f910f3ad5e347bca4eb9e9c904d5768"
  api_secret               = "d710021a5b04124f747830891c679679ebf3d250"
  api_url                  = "https://tet-pov-rtp1.cpoc.co/"
  disable_tls_verification = false
}