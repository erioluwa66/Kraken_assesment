

Infrastructure as Art: Crafting Resilient Microservices in Nomad

## A. Setup Instructions for nomad

Follow the instructions to setup  [Nomad](https://github.com/erioluwa66/Kraken_assesment/blob/master/nomad_setup/README.md).


## B. Setup Instructions for the Microservices app

Follow the instructions to setup the [Microservices app](https://github.com/erioluwa66/Kraken_assesment/blob/master/simple-microservice/README.md).

## C.   Security

### The below include would take to secure the cluster hosts in order to prevent privilege escalation, and unauthorized network and data access:

    a. Golden Images: Create standardized machine images with pre-configured security settings, such as firewall rules, security patches, and hardened system configurations. This ensures that every instance launched from these images adheres to your security baseline.

    b. Versioning and Tracking: Use Packer to version your images and keep a history of changes. This allows you to track which security features were included in each version and rollback to a previous version if necessary, By automating the image build process, you can ensure that only the necessary packages and services are included in your images, reducing the potential attack surface.

    c. Machine language and anomaly detection - deviation from derived patterns from data over a period of time.
    
    d. Mutual TLS (mTLS): Implement mTLS for all communication within the cluster to ensure that both the server and client authenticate each other’s certificates, preventing unauthorized access.

    e. Access Control Lists (ACLs): Use ACLs to define who can access what within the Nomad cluster. ACLs provide a way to grant capabilities to tokens, which can be used to authenticate and authorize actions.

    f. Namespaces: Utilize namespaces to isolate and control access to job information within a multi-tenant cluster. Namespaces help in segregating resources and access between different teams or projects.

    g. Sentinel Policies: For enterprise users, Sentinel policies offer granular control over components such as task drivers within a cluster.

### For structuring application secrets with a secrets management system like Vault, I would consider the following approach:

    a. Namespaces or Mounts: Create namespaces or dedicated mounts for each team within the organization structure. This allows you to isolate secrets and manage access at a granular level.

    b. Secrets Engines: Use different secrets engines for different types of secrets (e.g., AWS, database, KV) and mount them at paths dedicated to each team within the organization.

    c. Policies: Define policies that grant access to specific paths within Vault. These policies should be attached to tokens or entities representing teams or services.

    d. Roles and Service Accounts: When integrating with orchestration platforms like Nomad, bind service accounts to Vault roles that define the associated access policy for the application.

    e. Dynamic Secrets: Utilize Vault’s dynamic secrets capabilities to generate short-lived, on-demand secrets for applications, reducing the risk of secret sprawl and unauthorized access.

    f. Audit Logging: Enable audit logging in Vault to keep a detailed log of all operations, which can be invaluable for security audits and real-time analysis.

## D.   Scalability

### I would scale as traffic increases by:
    a. Horizontal Scaling: Add more client nodes to the Nomad cluster to distribute the workload. Even though I started with a single-node cluster, Nomad allows me to easily add more nodes as needed.

    b. Autoscaling: Implement the Nomad Autoscaler to automatically scale the number of instances of my services based on real-time demand.

    c. Hashicorp Packer: I can also use Packer to help in creating an immutable infrastructure, where servers are replaced rather than updated. This approach reduces the risk of configuration drift and makes it easier to scale out because new servers are created from a common image that has been proven to work.

    d. Terraform Modules: By organizing my Terraform code into modules, I can create reusable components that can be easily replicated to scale out services.

    e. Load Balancing: I would use a load balancer in front of the Nomad clients to distribute incoming traffic evenly across all available instances of the service.

    f. Resource Allocation: I would adjust resource allocation for jobs in Nomad to ensure that services have enough CPU, memory, and other resources to handle increased load.

### I would ensure reliability by:

    a. Transitioning from a single-node setup to a multi-node cluster with multiple server nodes to avoid a single point of failure. This ensures that if one server node fails, others can take over.
    
    b. configuring Nomad’s job specifications to automatically restart failed tasks and reschedule them on other nodes if necessary.

    c.Implementing comprehensive monitoring and alerting to detect issues early and respond quickly to traffic surges or node failures.

    d. ensuring to prepare disaster recovery plans, including backups and failover strategies, to quickly recover from catastrophic failures.

### Potential single points of failure currently include:
    a. Single Server Node: In a single-node cluster, the server node is a single point of failure. If it goes down, the entire cluster becomes unmanageable.

    b. Networking Issues: Network partitions or failures can isolate the Nomad node, preventing it from communicating with clients or external services.

    c. Storage: Relying on a single storage system for persistent data can be risky. Use replicated storage or cloud-based solutions to mitigate this risk.

## D.   Observability

###     Some key performance and health metrics for the service deployed at 2 include:

        a.  CPU usage is a critical metric, as it indicates how much processing power the service is consuming. High CPU usage could signify that the service is under heavy load, possibly leading to performance bottlenecks if not managed properly. Monitoring memory usage is equally important, as it reflects the amount of RAM being utilized by the service. Excessive memory consumption could lead to resource exhaustion, resulting in service instability or crashes.

        b. Health checks can also be configured to periodically verify the service's responsiveness and operational status. These checks should monitor both the application endpoints and the underlying infrastructure components.

        c. At the application level, monitoring request throughput, which measures the number of requests processed per second, helps gauge the service's load and performance. Response time, or the latency of the service, is another critical metric that affects user experience; increased response times can signal performance degradation. Error rates, which track the number of failed requests or transactions, are essential for identifying issues within the service, such as bugs or configuration problems.

## D.   Trobuleshooting

###     Some trouble shooting issues that may be encountered and ways to addres them:

        Cluster Autoscaler Issue:
            Problem: During high traffic, the server may crash due to insufficient CPU space.
            
            Resolution:
            
            Increase the scan-interval: This allows the cluster autoscaler to check for unschedulable pods more frequently.

            Decrease the scale-down-utilization-threshold: This ensures that nodes are not prematurely removed, which could lead to insufficient resources during traffic spikes.

            Ensure proper cloud provider integration: The cluster autoscaler should be configured to work seamlessly with your cloud provider for efficient scaling.

        Monitoring and Observability:
            Problem: Inadequate monitoring setup leading to missed alerts during high load. 
            
            Resolution:

            You can also use commands such as "nomad status", "nomad alloc logs  -tail -n 25 <allocation id>", nomad alloc status <allocation id> and more to identify issues with the cluster, reading the issues can provide guidance on options for resolution.

            Set up Prometheus to scrape metrics: Configure Prometheus to periodically pull metrics from your services.

            Configure Grafana dashboards: Use Grafana to create visualizations for the metrics collected by Prometheus.

            Define alert triggers: Set up AlertManager in Prometheus to send notifications via email, Slack, etc., when certain thresholds are exceeded.

        RBAC and Login Issues:
            Problem: Unable to log in to the cluster when out of the office, and need to maintain RBAC so others with authority can assume roles.
            Resolution:

            Use RBAC diagnostic checks: Utilize automated self-serve diagnostic checks to troubleshoot RBAC configuration issues.

            Delegate roles: Assign roles that allow other authorized users to assume necessary permissions in my absence.

            Regularly review and update roles: Ensure that roles and permissions are up-to-date with current organizational needs and security policies.


## D.   Future Improvements

###     Some future improvements I'd make include:

        a. Scalability:Implement horizontal cluster autoscaling to automatically add or remove clients from the Nomad cluster as the load changes.Explore multi-region deployments to distribute workloads and improve fault tolerance.

        b.Reliability:Introduce advanced node draining controls to smoothly transition workloads to new nodes during maintenance. Utilize Nomad’s rescheduling capabilities to automatically reschedule failed allocations to other nodes.

        c. Security:Integrate with HashiCorp Vault for secrets management to enhance security for sensitive data.Regularly update and patch the Nomad hosts following best practices to mitigate vulnerabilities.for the Docker images I can also  scan images after the build to ensure applications do not have any known unpatched critical or major vulnerabilities using tools such as dockerscout, snyk, whitesource or trivy.

        d. Terraform:  I may also use a remote backend like AWS S3 to store Terraform state files. This allows for collaboration and prevents local file loss or corruption. I eill also ensure to configure the backend with a DynamoDB table for state locking to ensure that only one Terraform process can modify the state at a time, avoiding conflicts and race conditions. another thing I will ensure to do is to enable versioning on my S3 bucket to keep a history of the state files. This  will allow me to roll back to previous versions if necessary and provides an audit trail of changes. It’s a critical practice to reduce the blast radius in case of misconfigurations or errors







  
