module "microservice-1" {
  source = "./modules/"
  service_name = "first"
}
module "microservice-2" {
  source = "./modules/"
  service_name = "second"
}

output "first-url" {
  value = module.microservice-1.service-url
}

output "second-url" {
  value = module.microservice-2.service-url
}