.RECIPEPREFIX +=
# Fixes the whole "make only likes tabs" thing
#
# Makefile for convenience


# Static configuration
ZONE=europe-west2-a
CLUSTER_NAME=kube-test

# Dynamic variables
PROJECT_ID=$(shell gcloud config list project --format=flattened | awk 'FNR == 1 {print $$2}')
MY_PATH=$(shell pwd)


#enable APIs needed for this example
enable-apis:
    gcloud --project "$(PROJECT_ID)" services enable compute.googleapis.com
    gcloud --project "$(PROJECT_ID)" services enable container.googleapis.com 

# create a preemptible 3 node cluster on the smallest nodes
create-cluster:
    gcloud --project "$(PROJECT_ID)" container clusters create "$(CLUSTER_NAME)" \
        --zone="$(ZONE)" \
        --machine-type=f1-micro \
        --num-nodes=3 \
        --disk-size=10 \
        --no-enable-cloud-logging \
        --no-enable-cloud-monitoring \
        --enable-autorepair \
        --preemptible

# create a cluster on n1-standard-2 nodes
create-cluster-n1:
    gcloud --project "$(PROJECT_ID)" container clusters create "$(CLUSTER_NAME)" \
            --zone="$(ZONE)" \
            --machine-type=n1-standard-2 \
            --num-nodes=3 \
            --disk-size=10 \
            --no-enable-cloud-logging \
            --no-enable-cloud-monitoring \
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
        --no-enable-cloud-monitoring \
        --enable-autorepair

# create a single node cluster on f1-micro
create-cluster-single:
    gcloud --project "$(PROJECT_ID)" container clusters create "$(CLUSTER_NAME)" \
        --zone="$(ZONE)" \
        --machine-type=f1-micro \
        --num-nodes=1 \
        --disk-size=10 \
        --no-enable-cloud-logging \
        --no-enable-cloud-monitoring \
        --enable-autorepair \

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
run-artillery:
    docker build $(HOME)/example-voting-app/art/ --tag=artillery:latest
    docker run -v $(HOME)/example-voting-app/art:/artillery --env \
    TARGET='http://$(shell make get-vote-ip)' artillery run /artillery/art.yaml

get-vote-ip:
    @kubectl get svc vote --template="{{range .status.loadBalancer.ingress}}{{.ip}}{{end}}"; echo ":\c"
    @kubectl get svc vote -o jsonpath='{.spec.ports[0].port}'; echo

get-result-ip:
    @kubectl get svc result --template="{{range .status.loadBalancer.ingress}}{{.ip}}{{end}}"; echo ":\c"
    @kubectl get svc result -o jsonpath='{.spec.ports[0].port}'; echo

test-fixme:
    bash -c 'external_ip=""; while [ -z $external_ip ]; do echo "Waiting for end point..."; external_ip=$(kubectl get svc result --template="{{range .status.loadBalancer.ingress}}{{.ip}}{{end}}"); [ -z "$external_ip" ] && sleep 10; done; echo "End point ready-" && echo $external_ip; export endpoint=$external_ip'
