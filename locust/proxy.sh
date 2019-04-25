#!/bin/bash

NAMESPACE=$1

export BASEPATH=$(dirname "$0")

#$BASEPATH/cluster/get-cluster.sh 

set -a
source $BASEPATH/cluster/config.sh
set +a


echo "Access in this URL: "
URL="http://localhost:8001/api/v1/proxy/namespaces/$NAMESPACE/services/locust-master:8089/"
echo "$URL"
open $URL
echo

kubectl --context=$KUBE_CONTEXT proxy