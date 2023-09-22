# Terraform-AWS-ECS-investigation
Develop terraform templates for creation and provisioning HA EKS cluster.  
Entire infrastructure should consist:  
1. VPC - public and private subnets  +
2. Bastion host with EIP  
3. Cluster nodes with a couple of containerized web-servers which should give a different response by port and path( "/api","/service"). By path **"/service"** available only from Bastion IP  
4. ALB with rules related to point 3  
5. Create CI/CD pipeline with AWS services to deliver artifact with nginx
перекинуть в терагрант !
github actions ( ci/cd part ) 
oidc 
Don't forget about code reusing and multi-environments.  
Use ECS awsvpc networking type to associate separate IP address to each ENI
