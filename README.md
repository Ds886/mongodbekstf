## DevOps Engineer Home Assignment
Below is a home assignment for a DevOps Engineer position. You are requested to:
1. Understand the requirements and use case. You may contact the interviewer for further clarification.
2. Implement and run your deployment plan for backend environment using the most efficient tools.
3. Present your deployment and result in the next interview session.

### Requirements
You are a DevOps engineer in a project of building an online orders system. Your task is to deploy a prototype created by the development team and make it available on the public internet.

Below is the information given by the development team.

### Global Environment Requirement
- Start a MongoDB instance, it should be reachable by the prototype code and the development team

### Backend Requirements
- NodeJS LTS version
- Set environment variable `MONGODB_URL="<mongodb connection url>"`, where `<mongodb connection url>` must match the [official mongodb node driver uri](https://docs.mongodb.com/drivers/node/current/fundamentals/connection/#connection-uri)
- Navigate to package(s) directory `cd packages/<package>`
- Build using npm `npm install`
- Start using node `node index.js`

### Cloud Infrastructure Requirement
Your deployment must meet the following criteria:
- A working deployment which reachable through internet
- IaC (Infrastructure as Code) deployment for the created AWS resources. You may use Cloudformation, Terraform or AWS CDK for that purpose 
- Documentation for the deployment plan and the resources created

### Guidebook on completing the assignment
- Your implementation should be commited to your own public git repository, including any IaC, documentation, etc (fork this repository)
- Create dockerfiles to match the deployment requirements
- Create all resources using IaC tools
- Use [Amazon Elastic Container Registry](https://us-east-1.console.aws.amazon.com/ecr/get-started) to push the images to a private repository
- Create a [Kubernetes](https://us-east-1.console.aws.amazon.com/eks/home) cluster
- Use helm to deploy the service(s)
- Create a MongoDB instance and make it reachable for the deployed service, update the `MONGODB_URL` environment variable to match the mongodb connection url 
- Expose the services to the internet using AWS Load Balancer, AWS Elastic IP, and Network Interface
- Document the deployment steps and the resources created in the deployment as clear and detailed as possible

### Bonus Points (Optional)
Bonus points are optional, but will be considered as a plus if implemented. Please prioritize completing the main requirements before investing time in the bonus section.
You may choose to implement one or more of the following:
- Supply the deployment with CI/CD automated process to push the image to ECR and deploy it to the cluster
- Monitor the service and handle recovery for different resources
- Maintain and handle the scaling of the service
- Maintain and handle high availability of the service according to best practices
- Secure the deployments according to best practices (rate limits, relevant security groups, etc)
- Consider multi-tenant and multi-environment deployment 
- Documentation for disaster recovery plan
- Any other improvement that you think is relevant for this project

### How will the assignment be evaluated
When evaluating the assignment, we will consider the following:
- The deployment plan and the resources are created and working as expected. We will trigger the API and expect a valid response
- The documentation is clear and detailed, we will follow the documentation to understand the deployment process
- Best practicies are followed across all functional and non-functional requirements (for example: security, cost optimization, reliability, etc)

### General Notes
- For performing the assignment, you will be given with AWS credentials (console and programmatic) to a dedicated account, **DO NOT COMMIT THEM IN THE CODE**
- Make sure to create small tier resources, as the prototype demands minimal working loads
- This assignment can be implemented in more than one way, if any further permissions are required for your implementation, contact us
- If you have any other questions, please do not hesitate to ask
