#!/usr/bin/env bash
set -e

cd "$(dirname "$0")/../terraform"

ALB_DNS=$(terraform output -raw alb_dns_name)

echo "ALB DNS: http://${ALB_DNS}"

echo
echo "Testing / ..."
curl -s "http://${ALB_DNS}/" || echo "Request failed"

echo
echo "Testing /health ..."
curl -s "http://${ALB_DNS}/health" || echo "Request failed"
echo

