1. Create a yugabyte cluster using the **gcpcluster.tf** file:- 
    * Follow guide here: https://github.com/YugaByte/terraform-gcp-yugabyt 
2. After the cluster creation, need to create a tserver on tiny vm.
    * launch a vm with 1gb ram and 1 vcpu inside gcp.
3. Install k3s on top of tiny vm: 
    * curl -sfL https://get.k3s.io | sh -
    * Refer https://github.com/rancher/k3s for more info
4. Deploy yugabyte tserver inside the k3s: 
    * kubectl create -f **yb_tserver.yaml**
5. Steps required before connecting tserver to master for k3s:-
    1. Add host file entries to the tiny vm with the tmaster addresses
        * kubectl exec -it yb-tserver-0 bash
        * vi /etc/hosts "35.197.122.195 yugabyte-vaibhav-n1.c.omni-163105.internal
                           34.83.51.84 yugabyte-vaibhav-n2.c.omni-163105.internal 
                           34.82.129.196 yugabyte-vaibhav-n3.c.omni-163105.internal"
        * Exit
6. Create the sample yb demo database and tables with the shell script:
    * ./**DataCreation.sh** (Pass the variable "tserver" with the name of your tserver pod)

Architecture Diagram:
![alt text](https://github.com/manish-infracloud/EdgeYuga/blob/development/Architecture.png)
