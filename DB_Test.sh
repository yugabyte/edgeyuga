#!/bin/bash
tmaster="yugabyte-vaibhav-n1"
function LoadData() {

    for i in {1..100};
    do
        $HOME/yugabyte-db/yb-software/yugabyte-2.0.0.0/bin/ysqlsh -h $tmaster -d yb_demo -c "select count(1) from orders;"
    sleep 3s;
    done
}
LoadData