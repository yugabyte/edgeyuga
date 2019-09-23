Create a yugabyte cluster using the tf file:-
follow guide here: https://github.com/YugaByte/terraform-gcp-yugabyte

Use gcpcluster.tf file and your json file to authenticate with google  xyz.json file
refered path to id rsa 

once cluster gets created, now will need to create a tserver on tiny vm.
launch a vm with 1gb ram and 1 vcpu.

once launched, now need to install k3s on top of it (Refer https://github.com/rancher/k3s)
curl -sfL https://get.k3s.io | sh -

once successfully installed, we will need to deploy yb-tserver inside the k3s:
kubectl create -f yb_tserver.yaml

//Once successfull now Steps required to connect tserver to master for k3s:-

add host file entried to the tiny vm 

kubectl exec -it yb-tserver-0 bash

vi /etc/hosts
//add following tmaster entries:-
35.197.122.195  yugabyte-vaibhav-n1.c.omni-163105.internal
34.83.51.84     yugabyte-vaibhav-n2.c.omni-163105.internal
34.82.129.196   yugabyte-vaibhav-n3.c.omni-163105.internal

exit

//for getting the sample yb demo database and tables:-

run the shell script:
 ./DataCreation.sh  (Pass the variable "tserver" with the name of your tserver)

Followed these steps in the script.

(
mkdir sql && cd sql
wget https://raw.githubusercontent.com/yugabyte/yb-sql-workshop/master/query-using-bi-tools/schema.sql
wget https://github.com/yugabyte/yb-sql-workshop/raw/master/query-using-bi-tools/sample-data.tgz
tar zxvf sample-data.tgz
kubectl cp ./schema.sql yb-tserver-0:/home/yugabyte/.
kubectl exec yb-tserver-0 mkdir data

kubectl cp ./data/orders.sql yb-tserver-0:/home/yugabyte/data/.
kubectl cp ./data/products.sql yb-tserver-0:/home/yugabyte/data/.
kubectl cp ./data/reviews.sql yb-tserver-0:/home/yugabyte/data/.
kubectl cp ./data/users.sql yb-tserver-0:/home/yugabyte/data/.

//Run ysqlsh to connect to the service:-
kubectl exec -it yb-tserver-0 /home/yugabyte/bin/ysqlsh -- -h yb-tserver-0  --echo-queries

//Create a database.
CREATE DATABASE yb_demo;
GRANT ALL ON DATABASE yb_demo to postgres;
\c yb_demo;

//Insert sample data
//First create the 4 tables necessary to store the data.
\i 'schema.sql';
//Now load the data into the tables.
\i 'data/products.sql'
\i 'data/users.sql'
\i 'data/orders.sql'
\i 'data/reviews.sql'
)


