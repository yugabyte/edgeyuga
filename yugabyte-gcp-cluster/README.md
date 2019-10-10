# yugabyte-gcp-cluster
Deploy and run YugaByte cluster on gcp and Tserver inside k3s.

## Pre-req
1. Hashicorp Terraform is installed on your machine. Follow [these](https://learn.hashicorp.com/terraform/getting-started/install.html) instructions, if it is not already installed.
2. GCP account with owner role. 

## Install Yugabyte Cluster on 3 nodes in GCP
0. Follow instructions [here](https://cloud.google.com/docs/authentication/getting-started) to create a service account & create a gcp credentials json file.
1. Clone this repo: ``` git clone git@github.com:infracloudio/EdgeYuga.git ```
2. Change to yugabyte-gcp-cluster directory in the cloned directory
3. Edit **yb_cluster_gcp.tf** file to update the location of the credentials json file created in step #0.
4. Update your project id (you can find it in gcp dashboard under Project info: Project ID)
5. Update path to key pair and user for your host machine (default location is $HOME/.ssh/id_rsa.pub & id_rsa). Generate a new following steps from [here](https://www.ssh.com/ssh/keygen/).
5. Now for creating the instances and bring up the cluster follow below steps:-  
   * Init terraform first if you have not already done so.

    ```
    $ terraform init
    ```

   * To check what changes are going to happen in the environment run the following 

    ```
    $ terraform plan
    ```

   * Now run the following to create the instances and bring up the cluster.

    ```
    $ terraform apply
    ```

   * Once the cluster is created, you can go to the URL `http://<node ip or dns name>:7000` to view the UI. You can find the node's ip or dns by running the following:

    ```
    terraform state show google_compute_instance.yugabyte_node[0]
    ```
    For detailed usage check "Usage" section [here](https://github.com/yugabyte/terraform-gcp-yugabyte)

## Config
1. After the cluster creation, deploy a tiny vm and install k3s in gcp.
    * launch a custom vm with 1 gb ram and 1 vcpu.
    * Install k3s on top of tiny vm: 
        * ``` curl -sfL https://get.k3s.io | sh - ```
        * Refer https://github.com/rancher/k3s for more info
2. Deploying yugabyte tserver inside the k3s:
    *  In **yb_tserver_tinygcp.yaml** file modify:-
        * "tserver_master_addrs" section with the ybcluster external ip addresses with port 7100.
        * "hostAliases" section and add ip addreses and hostnames for each tmaster node from cluster.(you can find hostnames on yb ui home and ip's on gcp console).
    * Run ``` kubectl create -f yb_tserver_tinygcp.yaml ```
3. Create, load & test the sample yb_demo database and tables using below scripts:
    * From the gcp tiny vm run:-
    (Pass value to the variable "tserver" with the name of your tserver pod, default value set is "yb-tserver-0")
        * ``` ./DB_Init.sh ``` (Creates the database and tables)
        * ``` ./DB_Load.sh ``` (Starts loading the data in table "orders" )
    * From your home location inside yb-tmaster cluster's node run:-
    (Pass value to the variable "tmaster" with the name of your tmaster node)
        * ``` ./DB_Test ``` (Shows the counts for the table "orders" )

Architecture Diagram:
![alt text](https://github.com/infracloudio/EdgeYuga/blob/development/yugabyte-gcp-cluster/Architecture.png)
