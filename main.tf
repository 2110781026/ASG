module "microservice-1" {
  source = "./modules/"
  service_name = "first"
}

output "first-url" {
  value = module.microservice-1.service-url
}

/*
module "microservice-2" {
  source = "./modules/"
  service_name = "second"
}

output "second-url" {
  value = module.microservice-2.service-url
}
*/