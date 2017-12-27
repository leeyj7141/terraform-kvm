#!/bin/sh

TYPE="kolla_vms"

TERRAFORM_BIN="${PWD}/../bin/terraform"

WORK_DIR="${PWD}/../data/tf/${TYPE}"
STATE_DIR="${PWD}/../state"

${TERRAFORM_BIN} destroy -force \
 -var-file=${WORK_DIR}/../default.tfvars \
 -var-file=${WORK_DIR}/../networks.tfvars \
 -var-file=${WORK_DIR}/../${TYPE}.tfvars \
 -state=${STATE_DIR}/${TYPE}/terraform.tfstate \
 ${WORK_DIR}

if [ $? -ne 0 ]; then
    exit 1;
fi
