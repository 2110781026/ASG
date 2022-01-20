module "microservice-1" {
  source = "./modules/"
  service_name = "first"
}
output "first-url" {
  value = module.microservice-1.service-url + "/index.html"
}