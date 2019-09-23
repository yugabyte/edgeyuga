#!/bin/bash
tserver="yb-v-tserver-0"
files=("orders" "products" "reviews" "users")

function getFiles() {
    mkdir demo_data && cd $_
    wget https://raw.githubusercontent.com/yugabyte/yb-sql-workshop/master/query-using-bi-tools/schema.sql
    wget https://github.com/yugabyte/yb-sql-workshop/raw/master/query-using-bi-tools/sample-data.tgz
    tar zxvf sample-data.tgz
    kubectl cp ./schema.sql $tserver:/home/yugabyte/.
    kubectl exec $tserver mkdir data
}
getFiles

sleep 3s

function copyFiles() {
   arr=("$@")
   for i in "${arr[@]}";
      do
          kubectl cp ./data/$i.sql $tserver:/home/yugabyte/data/.
      done

}
copyFiles "Copying" "${files[@]}"

function createDatabase() {
    //Run ysqlsh to connect to the service:-
    kubectl exec -it $tserver /home/yugabyte/bin/ysqlsh -- -h $tserver  --echo-queries
    sleep 10s
    //Create a database.
    CREATE DATABASE yb_demo;
    GRANT ALL ON DATABASE yb_demo to postgres;
    \c yb_demo;
    //Insert sample data, First create the 4 tables necessary to store the data.
    \i 'schema.sql';
    sleep 5s
    //Now load the data into the tables.
    \i 'data/products.sql'
    \i 'data/users.sql'
    \i 'data/orders.sql'
    \i 'data/reviews.sql'
}
createDatabase