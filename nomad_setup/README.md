# Kraken_assesment

A take home assisgnment from the Kraken team
## Prerequisites
    AWS
    Terraform
    Git Bash or any terminal
## Setup Instructions for the Microservices app

1) Change directory to nomad_setup
    ```
    cd nomad-setup/aws
    
    ```
2) Update the region variable in terraform.tfvars with your AWS region preference. Save the file.
    a. aws/terraform.tfvars
        ```
        region      = "us-east-2"
         ```
3) Deploy the Nomad cluster
    Initialize Terraform to download required plugins and set up the workspace.
    ```    
        terraform init
    ```
Provision the resources. Respond yes to the prompt to confirm the operation. The provisioning takes a couple of minutes.

4)  Verify cluster availability  
    ![Snapshot of Terraform output](./image/image0.png)

    Put the URL in your output in your browser to open the Web UI
    ![Web UI picture](./image/image1.png)

5)  Set up Nomad
    Export the cluster address as the NOMAD_ADDR environment variable.
    ```
        export NOMAD_ADDR=$(terraform output -raw nomad_ip)
    ```
    Bootstrap the ACLs and save the management token to a file.
    ![bootstrap_image](./image/image7.png)
    ```
        nomad acl bootstrap | \
            grep -i secret | \
            awk -F "=" '{print $2}' | \
            xargs > nomad-management.token

    ```
        
    Export the cluster address as the NOMAD_ADDR environment variable.
    ```
        export NOMAD_ADDR=$(terraform output -raw nomad_ip)
    ```
6) Verify connectivity
    ![image showing status of nodes](./image/image2.png)
    ![clients](./image/image3.png)
    ![Server](./image/image4.png)
 
7) Change directory to jobs
    ```
       cd jobs
        nomad job run simple-microservice-web.nomad.hcl
    ```
    ![deployed job](./image/image5.png)

    url to test the app
    ![Link to test image](./image/image6.png)

8)  To Verify the job status and check the logs for any errors:
    ```
     nomad job status simple-microservice-web
        nomad alloc logs <allocation-id>
    ```
9) Clean up the application
  ```
    nomad job stop -purge simple-microservice-web
    terraform destroy

    ```
