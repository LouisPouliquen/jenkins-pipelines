#!/bin/bash

set -e

JENKINS_URL="http://localhost:8080"
JOB_NAME="taskb-pipeline"
REPO_URL="https://github.com/LouisPouliquen/jenkins-pipelines.git"

# 1. Download Jenkins CLI
if [ ! -f jenkins-cli.jar ]; then
  echo "Downloading Jenkins CLI..."
  curl -s -O "$JENKINS_URL/jnlpJars/jenkins-cli.jar"
fi

# 2. Wait for Jenkins to be ready
echo "Waiting for Jenkins to be available..."
until curl -s "$JENKINS_URL" | grep -q "Authentication required\|Unlock Jenkins\|Dashboard"; do
  sleep 2
done
echo "Jenkins is ready."

# 3. Prepare job config XML
echo "Generating multibranch pipeline job config..."
cat <<EOF > multibranch-config.xml
<org.jenkinsci.plugins.workflow.multibranch.WorkflowMultiBranchProject plugin="workflow-multibranch">
  <description>Pipeline B for taskb branch</description>
  <properties/>
  <sources class="jenkins.branch.MultiBranchProject\$BranchSourceList" plugin="branch-api">
    <data>
      <jenkins.branch.BranchSource>
        <source class="hudson.plugins.git.GitSCMSource" plugin="git">
          <id>taskb-source</id>
          <remote>${REPO_URL}</remote>
        </source>
        <strategy class="jenkins.branch.DefaultBranchPropertyStrategy">
          <properties class="empty-list"/>
        </strategy>
      </jenkins.branch.BranchSource>
    </data>
  </sources>
  <factory class="org.jenkinsci.plugins.workflow.multibranch.WorkflowBranchProjectFactory">
    <scriptPath>Jenkinsfile</scriptPath>
  </factory>
</org.jenkinsci.plugins.workflow.multibranch.WorkflowMultiBranchProject>
EOF

# 4. Create job
echo "Creating Jenkins job '${JOB_NAME}'..."
java -jar jenkins-cli.jar -s "$JENKINS_URL" create-job "$JOB_NAME" < multibranch-config.xml

# 5. Trigger job indexing and build
echo "Triggering branch indexing..."
java -jar jenkins-cli.jar -s "$JENKINS_URL" reload-job "$JOB_NAME"
sleep 3

echo "Waiting for branch 'taskb' to be detected..."
until java -jar jenkins-cli.jar -s "$JENKINS_URL" list-jobs "$JOB_NAME" | grep -q "taskb"; do
  sleep 2
done

echo "Triggering build for branch 'taskb'..."
java -jar jenkins-cli.jar -s "$JENKINS_URL" build "${JOB_NAME}/taskb"

echo "✅ Pipeline B setup complete. Monitor progress in the Jenkins UI at: $JENKINS_URL/job/$JOB_NAME/"
