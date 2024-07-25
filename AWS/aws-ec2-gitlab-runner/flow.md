
```plaintext
                                 +----------------------+
                                 |                      |
                                 |    GitLab Server     |
                                 |  (gitlab.com or self-|
                                 |   hosted instance)   |
                                 |                      |
                                 +----------------------+
                                             |
                                             | Registration
                                             | Token
                                             v
                                 +----------------------+
                                 |                      |
                                 |  AWS Infrastructure  |
                                 |                      |
                                 +----------------------+
                                             |
                                             | Terraform
                                             | Configuration
                                             v
       +--------------------------------------------+
       |                                            |
       |                AWS Region                  |
       |             (e.g., us-east-1)              |
       |                                            |
       +--------------------------------------------+
                                             |
                                             |
         +-------------------------------+   |
         |                               |   |
         |  VPC                          |   |
         |                               |   |
         | +---------------------------+ |   |
         | |                           | |   |
         | |  Security Group           | |   |
         | |  (gitlab-runner-sg)       | |   |
         | |   Ingress:                | |   |
         | |    - Port 22 (SSH)        | |   |
         | |      0.0.0.0/0            | |   |
         | |   Egress:                 | |   |
         | |    - All traffic          | |   |
         | |      0.0.0.0/0            | |   |
         | |                           | |   |
         | +---------------------------+ |   |
         |                               |   |
         |                               |   |
         | +---------------------------+ |   |
         | |                           | |   |
         | |  EC2 Instance             | |   |
         | |  (GitLab Runner)          | |   |
         | |   - AMI: Amazon Linux 2   | |   |
         | |   - Instance Type: t2.micro||   |
         | |   - Key Pair: your-key-pair||   |
         | |   - User Data:            | |   |
         | |     Install & Register    | |   |
         | |     GitLab Runner         | |   |
         | |                           | |   |
         | +---------------------------+ |   |
         |                               |   |
         +-------------------------------+   |
                                             |
                Outputs:                     |
                - Instance ID                |
                - Instance Public IP         |
                                             |
                                             v
                                 +----------------------+
                                 |                      |
                                 |  Administrator's     |
                                 |     Workstation      |
                                 |                      |
                                 +----------------------+
                                             |
                                             | SSH Access
                                             v
```
