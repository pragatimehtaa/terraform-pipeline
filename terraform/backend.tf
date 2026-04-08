terraform {
  cloud {
    organization = "PTM"

    workspaces {
      name = "terraform-pipeline"
    }
  }
}