.RECIPEPREFIX +=
# Fixes the whole "make only likes tabs" thing
#
# Makefile for convenience
# 
# would be nice to be able to pull exposed services into environment variables
# also need to figure out most elegant way to run
# would be nice to see votes flip back and forth

# Static configuration
ZONE=europe-west2-a
CLUSTER_NAME=kube-test

# Dynamic variables
PROJECT_ID=$(shell gcloud config list project --format=flattened | awk 'FNR == 1 {print $$2}')
MY_PATH=$(shell pwd)

# create a preemptible 3 node cluster on the smallest nodes
create-cluster:
    gcloud --project "$(PROJECT_ID)" container clusters create "$(CLUSTER_NAME)" \
        --zone="$(ZONE)" \
        --machine-type=f1-micro \
        --num-nodes=3 \
        --disk-size=10 \
        --no-enable-cloud-logging \
        --enable-autorepair \
        --preemptible

# create a 3 node cluster on standard f1-micros
create-cluster-nopreempt:
    gcloud --project "$(PROJECT_ID)" container clusters create "$(CLUSTER_NAME)" \
        --zone="$(ZONE)" \
        --machine-type=f1-micro \
        --num-nodes=3 \
        --disk-size=10 \
        --no-enable-cloud-logging \
        --enable-autorepair

# delete the cluster
delete-cluster:
    gcloud --project "$(PROJECT_ID)" container clusters delete "$(CLUSTER_NAME)" \
        --zone="$(ZONE)"

# apply the deployment file (declarative)
apply-deployments:
    kubectl apply -f gcr-kube.yaml

# create deployments from file (imperative)
create-deployments:
    kubectl create -f gcr-kube.yaml

# delete the deployments created from the gcr-kube.yaml file
delete-deployments:
    kubectl delete deployment,service db redis vote worker result

# docker run command to run artillery locally to generate load
run-art:
    docker run -v /home/ianp/example-voting-app/art/csv-art.yaml:/home/node/artillery/csv-art.yaml \
        -v /home/ianp/example-voting-app/art/out.csv:/home/node/artillery/out.csv \
        gcr.io/kube-226720/artillery:latest run csv-art.yaml

# docker run command to run artillery locally to generate load
# use dynamic local path
run-art2:
    docker run -v $(MY_PATH)/example-voting-app/art/csv-art.yaml:/home/node/artillery/csv-art.yaml \
        -v $(MY_PATH)/example-voting-app/art/out.csv:/home/node/artillery/out.csv \
        gcr.io/kube-226720/artillery:latest run csv-art.yaml