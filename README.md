1. Create a yugabyte cluster using the **yb_cluster_gcp.tf** file:- 
    * Follow guide here: https://github.com/YugaByte/terraform-gcp-yugabyt 
    * Once the cluster is created, you can go to the URL http://<node ip or dns name>:7000 to view the UI. 
2. After the cluster creation, deploy a tiny vm and install k3s in gcp.
    * launch a vm with 1gb ram and 1 vcpu.
    * Install k3s on top of tiny vm: 
        * ``` curl -sfL https://get.k3s.io | sh - ```
        * Refer https://github.com/rancher/k3s for more info
4. Deploying yugabyte tserver inside the k3s:
    *  In **yb_tserver_tinygcp.yaml** file modify:-
        * "tserver_master_addrs" section with the ybcluster external ip addresses with port 7100.
        * "hostAliases" section and add ip addreses and hostnames for each tmaster node from cluster.(you can find hostnames on yb ui home and ip's on gcp console).
    * Run ``` kubectl create -f yb_tserver_tinygcp.yaml ```
5. Create, load & test the sample yb_demo database and tables using below scripts:
    * From the gcp tiny vm run:-
    (Pass value to the variable "tserver" with the name of your tserver pod, default value set is "yb-tserver-0")
        * ./**DB_Init.sh** (Creates the database and tables)
        * ./**DB_Load.sh** (Starts loading the data in table "orders" )
    * From your home location inside yb-tmaster cluster's node run:-
    (Pass value to the variable "tmaster" with the name of your tmaster node)
        * ./**DB_Test** (Shows the counts for the table "orders" )

Architecture Diagram:
![alt text](https://github.com/manish-infracloud/EdgeYuga/blob/development/Architecture.png)
