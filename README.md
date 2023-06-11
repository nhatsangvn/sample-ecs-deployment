```
docker build -t rg-ops .
docker run -p 3000:3000 rg-ops
```

# Quickstart guide:
## Simple flow
```
CLIENT -- sg:lb-secgroup -> [ALB]:443 -- sg:lb-to-ecs --> [ECS] with public-ip <--> ECR repo
                |                           |                                           ^
          all:port 80/443             only from lb-secgroup                          updated
                                                                                        |
* sg = security group                                                                 ci.sh
* lb = loadbalancer                                                     
```
## Assume
+ A machine with Terrform annd Docker installed, has enough AWS permisison to use ECR, ECS and EC2
+ Already imported TLS Certs with matching domain api.sohan.cloud
+ Will map the domain api.sohan.cloud to ALB after creation

1. establish the infrastructure: create ECR repository and build the first image
```
# create the base image repository
terraform -chdir=./deployment/base apply # yes

# push the very first image
bash ci.sh
```

2. deploy other services: we can call to our domain after this
```
terraform -chdir=./deployment/services apply # yes
# note the lb-dns output string -> will need to mapping DNS on the NS Provider
```

3. deploy new code
```
# update the corresponding IMAGE_AWS_REGION in ci.sh
# is used to build the new docker image and push to ECR
bash ci.sh

# apply the new latest image
terraform -chdir=./deployment/services apply # yes
```

# (Probably) Block tasks 
- How to add certs to ALB with IaC ? => To be researched.

# Optimization
- [ ] No ENV in Dockerfile 
- [ ] Image size
- [ ] Image should be built with build-in HTTPS
- [ ] Autoscale on load
- [ ] Monitoring
- [ ] Rollback on error?
- [ ] Multi enviroment
- [ ] Multi regions

# Check list
1. Create ECR image => get image path 

- [x] Do with UI
- [x] IaC

2. Create task definition

- [x] Do with UI
- [x] IaC

3. Create cluster from 2.

- [x] Do with UI
- [x] IaC

4. Create lb with secgroup lb-secgroup <br>
4a. Create listener 443 <br>
4b. Create target-group with IP

- [x] Do with UI (seperated secgroup with port 80,443)
- [x] IaC

5. Create fargate service mapped from 3. and mapped to lb

- [x] Do with UI (use public ip on services and allow secgroup from LB - Fargate)
- [x] IaC

6. Add domain/certs to LB

- [x] Do with UI 

7. Test on the domain: https://api.sohan.cloud

- [x] Done

