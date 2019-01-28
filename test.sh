#!/bin/bash
'$external_ip=""; \
while [ -z $external_ip ]; \
do echo "Waiting for end point..."; \
external_ip=$(kubectl get svc staging-voting-app-vote --template="{{range .status.loadBalancer.ingress}}{{.ip}}{{end}}"); \
[ -z "$external_ip" ] && sleep 10; done; echo "End point ready-" && echo $external_ip; cf_export endpoint=$external_ip'
