terraform {
  required_providers {
    tetration = {
      source = "CiscoDevNet/tetration"
      version = "0.1.1"
    }
  }
}

provider "tetration" {
  api_key                  = "API KEY"
  api_secret               = "SECRET"
  api_url                  = "CSW URL"
  disable_tls_verification = false
}