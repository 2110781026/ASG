# ASG
Auto Scaling Group - FHB Exercise


### Diagram ###
![alt text](https://raw.githubusercontent.com/2110781026/ASG/main/diagram.JPG)

### Description ###
If you deploy the code via Terraform you will receive a nginx webserver which acts 
as reverse proxy two two other services. Theese Services offer a Moustache and 
a happy cloud.

### Instructions ###

Be sure that you change you check your
```
.aws/credentials
```
before you start. 

Clone the repository and use 
```
Terraform init 
Terraform plan
Terraform apply
```

You will deploy the service. Be aware that it takes a fair amount of Time (up to 10 minutes) before the service is available.

### Adding Instances ###

In the Top main.tf you will find a commented Block 

```
module "microservice-2" {
  source = "./modules/"
  service_name = "second"
}

output "second-url" {
  value = module.microservice-2.service-url
}
```
uncomment it for a second service deployment. 

Copy and Change Output, Module and Value as often as you like 
to produce as many deployments as you like. 

