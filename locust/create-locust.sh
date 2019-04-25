#!/bin/bash

while getopts ":n:h:t:r:" opt; do
  case $opt in
    n) NAMESPACE="$OPTARG"
    ;;
    h) TARGET_HOST="$OPTARG"
    ;;
    t) TASKS_FILE="$OPTARG"
    ;;
    r) REPLICAS="$OPTARG"
    ;;
    \?) echo "Invalid option -$OPTARG" >&2
    exit 1
    ;;
  esac
done


export NAMESPACE TARGET_HOST REPLICAS
export BASEPATH=$(dirname "$0")



echo
echo "    ➔  Creating namespace $NAMESPACE"
CREATE_NS="chronic kubectl --context=$KUBE_CONTEXT create ns $NAMESPACE"
if $CREATE_NS ; then
    echo "    ✅  Namespace successfully created"
else
    echo "    ⚠  Namespace $NAMESPACE already created"
fi

echo
echo "    ➔  Creating configmap tasks from file $TASKS_FILE"
chronic kubectl --context=$KUBE_CONTEXT -n $NAMESPACE delete cm tasks > /dev/null 2>&1 || true
CREATE_CONFIGMAP="chronic kubectl --context=$KUBE_CONTEXT -n $NAMESPACE create cm tasks --from-file=$TASKS_FILE"
if $CREATE_CONFIGMAP ; then
    echo "    ✅  Configmap tasks successfully created"
else
    echo "    ❌  Error creating configmap tasks"
    exit 1
fi

RESOURCES=$(ls $BASEPATH/*.yaml)
export TASKS_FILE=$(basename $TASKS_FILE)
for RESOURCE in $RESOURCES; do
echo
echo "    ➔  Creating $RESOURCE"
    SUBST=$(envsubst < $BASEPATH/$RESOURCE > /tmp/$RESOURCE.tmp )
    CREATE_RESOURCE="chronic kubectl --context=$KUBE_CONTEXT apply -f /tmp/$RESOURCE.tmp"
    if $CREATE_RESOURCE ; then
        rm /tmp/$RESOURCE.tmp
        echo "    ✅  $RESOURCE successfully created"
    else
        echo "    ❌  Error creating $RESOURCE"
        exit 1
    fi

done


statuses="kubectl --context=$KUBE_CONTEXT -n $NAMESPACE get pods -l name=locust  -o jsonpath={.items[*].status.containerStatuses[*].ready}"
READY="false"
COUNTER=0
echo "Waiting for locust to become ready..."
while [ "$READY" == "false" ] && [ $COUNTER -lt 60 ]; do
    READY="true"
    let COUNTER=COUNTER+1
    sleep 5
    for STATUS in $($statuses); do
        if [ "$STATUS" != "true" ]; then
                READY="false"
        fi
    done
done

if [ "$READY" = "false" ]; then
    echo "timeout exceeded"
    echo "    ❌  Error creating locust"
    exit 1
fi

SVC_HOSTNAME=$(kubectl --context=$KUBE_CONTEXT -n $NAMESPACE get svc locust-master -o jsonpath="{.status.loadBalancer.ingress[*].hostname}")

echo
echo "⚐  Finished"
echo "   Available at: http://$SVC_HOSTNAME:8089"


