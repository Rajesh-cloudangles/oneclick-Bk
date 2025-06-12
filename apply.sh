#!/bin/bash

cd /home/ubuntu/tf-files/ && terraform apply  -var-file="mlops-dev.tfvars" -auto-approve
