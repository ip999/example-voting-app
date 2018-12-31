Example Voting App
=========

TODO
----

* Figure out the rest of the automation, so the artillery.io container can either run in kubernetes or be run from different environments without needing modification (passing of URL for vote app, and re-build container).
* or do different options "vote xxx cats / vote yyy dogs" etc?
* Implement autoscaling options (understand node-pools)
* Implement workflow for declarative configuration update
* Integrate Istio (see https://github.com/thesandlord/Istio101)


What is it?
-----------

A simple distributed application running across multiple Docker containers. Forked from  (https://github.com/dockersamples/example-voting-app) and modified to run in GKE. Handy Makefile implementation idea stolen from https://github.com/thesandlord/Istio101.

Getting started
---------------

Run the app in Kubernetes
-------------------------

The folder k8s-specifications contains the yaml specifications of the Voting App's services.

First create the vote namespace

```
$ kubectl create namespace vote
```

Run the following command to create the deployments and services objects:
```
$ kubectl create -f k8s-specifications/
deployment "db" created
service "db" created
deployment "redis" created
service "redis" created
deployment "result" created
service "result" created
deployment "vote" created
service "vote" created
deployment "worker" created
```

The vote interface is then available on port 31000 on each host of the cluster, the result one is available on port 31001.

Architecture
-----

![Architecture diagram](architecture.png)

* A front-end web app in [Python](/vote) which lets you vote between two options
* A [Redis](https://hub.docker.com/_/redis/) queue which collects new votes
* A [Java](/worker/src/main) worker which consumes votes and stores them in…
* A [Postgres](https://hub.docker.com/_/postgres/) database backed by a Docker volume
* A [Node.js](/result) webapp which shows the results of the voting in real time


Note
----

The original voting application only accepted one vote per client, this has been brutally modified (by ignoring cookie checks).
