Example Voting App
=========

TODO
----

* or do different options "vote xxx cats / vote yyy dogs" etc?
* Implement autoscaling options (understand node-pools)
* Implement workflow for declarative configuration update
* Integrate Istio (see https://github.com/thesandlord/Istio101)
* Figure out the rest of the automation, so the artillery.io container can either run in kubernetes or be run from different environments without needing modification (passing of URL for vote app, and re-build container).


What is it?
-----------

A simple distributed application running across multiple Docker containers. Forked from the docker sample voting app (https://github.com/dockersamples/example-voting-app) and modified to run in GKE. Handy Makefile implementation idea stolen from https://github.com/thesandlord/Istio101.

Getting started
---------------

look in the Makefile for the various recipies to build a cluster and deploy the application containers. 

Basic getting started:

`make create-cluster` to create the kubernetes cluster on GKE (takes a couple of minutes)

`make create-deployments` to deploy the vote application

`make run-art` to generate some artificial load ## not completed the automation yet, currently the appropate URL adding manually

The vote interface is then available on port 5000, the result one is available on port 5001.

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
