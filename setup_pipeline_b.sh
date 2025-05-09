#!/bin/bash

set -e

JENKINS_URL="http://localhost:8080"
JOB_NAME="${1:-taskb-pipeline}"
CONFIG_FILE="multibranch-config.xml"

# 1. Download Jenkins CLI
if [ ! -f jenkins-cli.jar ]; then
  echo "Downloading Jenkins CLI..."
  curl -s -O "$JENKINS_URL/jnlpJars/jenkins-cli.jar"
fi

# 2. Wait for Jenkins to be available
echo "Waiting for Jenkins to be available..."
until curl -s "$JENKINS_URL" | grep -q "Dashboard\|Unlock Jenkins"; do
  sleep 2
done
echo "Jenkins is ready."

# 3. Create or update job
if java -jar jenkins-cli.jar -s "$JENKINS_URL" get-job "$JOB_NAME" >/dev/null 2>&1; then
  echo "Updating existing job $JOB_NAME..."
  java -jar jenkins-cli.jar -s "$JENKINS_URL" update-job "$JOB_NAME" < "$CONFIG_FILE"
else
  echo "Creating new job $JOB_NAME..."
  java -jar jenkins-cli.jar -s "$JENKINS_URL" create-job "$JOB_NAME" < "$CONFIG_FILE"
fi