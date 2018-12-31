.RECIPEPREFIX +=

PROJECT_ID=$(shell gcloud config list project --format=flattened | awk 'FNR == 1 {print $$2}')
ZONE=europe-west2-a
CLUSTER_NAME=kube-test

create-cluster:
    gcloud --project "$(PROJECT_ID)" container clusters create "$(CLUSTER_NAME)" \
        --zone="$(ZONE)" \
        --machine-type=f1-micro \
        --num-nodes=3 \
        --disk-size=10 \
        --no-enable-cloud-logging \
        --enable-autorepair\
        --preemptible

delete-cluster:
    gcloud --project "$(PROJECT_ID)" container clusters delete "$(CLUSTER_NAME)" \
        --zone=europe-west2-a

create-deployments:
    kubectl apply -f example-voting-app/gcr-kube.yaml

delete-deployments:
    kubectl delete deployment,service db redis worker vote result redmon

run-art:
    docker run -v /home/ianp/example-voting-app/art/csv-art.yaml:/home/node/artillery/csv-art.yaml \
        -v /home/ianp/example-voting-app/art/out.csv:/home/node/artillery/out.csv gcr.io/kube-226720/artillery:latest run csv-art.yaml
