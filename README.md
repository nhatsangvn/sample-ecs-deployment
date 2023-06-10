```
docker build -t rg-ops .
docker run -p 3000:3000 rg-ops
```

# (Probably) Block tasks 
- How to push iamge to ECR with IaC ? => Should be some EC2 instance with access to both Git repo and ECR.
- How to add certs to ALB with IaC ? => To be researched.

# Assume
+ Have the image in ECR with tag latest
+ Need to import TLS Certs Manually
+ Mapping the domain api.sohan.cloud to ALB beforehand

```
CLIENT -- sg:lb-secgroup -> [LB]:443 -- sg:lb-to-ecs --> [ECS] with public-ip
                |                           |
          all:port 80/443             only from lb-secgroup
```

# Check list
1. Create ECR image => get image path 

- [x] Do with UI
- [ ] IaC

2. Create task definition

- [x] Do with UI
- [ ] IaC

3. Create cluster from 2.

- [x] Do with UI
- [ ] IaC

4. Create lb with secgroup lb-secgroup
4a. Create listener 443
4b. Create target-group with IP

- [x] Do with UI (seperated secgroup with port 80,443)
- [ ] IaC

5. Create fargate service mapped from 3. and mapped to lb

- [x] Do with UI (use public ip on services and allow secgroup from LB - Fargate)
- [ ] IaC

6. Add domain/certs to LB

- [x] Do with UI 

7. Test on the domain: https://api.sohan.cloud


# Optimization
- [ ] No ENV in Dockerfile 
- [ ] Iamge should be built with build-in HTTPS?
- [ ] Encryption on ECR image?
- [ ] Autoscale on load?
