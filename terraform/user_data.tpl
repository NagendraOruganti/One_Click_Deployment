#!/bin/bash
set -xe

yum update -y
yum install -y java-17-amazon-corretto-headless awscli

APP_DIR="/opt/demo-api"
JAR_NAME="demo-api.jar"

mkdir -p "$APP_DIR"
cd "$APP_DIR"

# Use the variables passed from Terraform
aws s3 cp "s3://${app_s3_bucket}/${app_s3_key}" "./$${JAR_NAME}"

cat >/etc/systemd/system/demo-api.service <<EOF
[Unit]
Description=Demo Java REST API
After=network.target

[Service]
User=root
WorkingDirectory=$${APP_DIR}
ExecStart=/usr/bin/java -jar $${APP_DIR}/$${JAR_NAME}
SuccessExitStatus=143
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable demo-api
systemctl start demo-api
