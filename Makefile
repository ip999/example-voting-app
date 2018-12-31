.RECIPEPREFIX +=

create-cluster:
    gcloud --project=kube-226720 container clusters create kube-test \
        --zone=europe-west2-a \
        --machine-type=f1-micro \
        --num-nodes=3 \
        --disk-size=10 \
        --no-enable-cloud-logging \
        --enable-autorepair\
        --preemptible

delete-cluster:
    gcloud --project=kube-226720 container clusters delete kube-test \
        --zone=europe-west2-a

create-deployments:
    kubectl create -f example-voting-app/gcr-kube.yaml

delete-deployments:
    kubectl delete deployment,service db redis worker vote result redmon

run-art:
    docker run -v /home/ianp/example-voting-app/art/csv-art.yaml:/home/node/artillery/csv-art.yaml \
        -v /home/ianp/example-voting-app/art/out.csv:/home/node/artillery/out.csv gcr.io/kube-226720/artillery:latest run csv-art.yaml