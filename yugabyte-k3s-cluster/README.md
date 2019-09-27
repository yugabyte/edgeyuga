# yugabyte-k3s-cluster
Deploy and run YugaByte DB on k3s.

## Config
* First create an instance
1. Deploy a standard vm in gcp (2 vCPU, 7.5 GB memory).
    * Install k3s in it: 
        * ``` curl -sfL https://get.k3s.io | sh - ```
        * Refer https://github.com/rancher/k3s for more info on k3s.
2. Deploy yugabyte cluster inside the k3s:
    * Run ``` kubectl create -f **yugabyte-cluster.yaml** ```
3. Now for testing, lets create, load & test the sample yb_demo database and tables using below scripts:
    * From the host vm run:-
    (Pass value to the variable "tserver" with the name of your tserver pod, default value set is "yb-tserver-0")
        * Create the database and tables
        ``` ./**DB_Init.sh** ``` 
        (Try to run below both scripts at the same time to verify real time data)
        * Now start loading the data in table "orders" 
        ``` ./**DB_Load.sh** ```
        * Open host vm in new window and run the test script :-
        ``` ./**DB_Test** ``` 
        (Pass value to the variable "host" with the name of your tserver node)
        
        If your are getting output with increasing number of counts for the table "orders" you have successfully configured the yugabyte DB.

