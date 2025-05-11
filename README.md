# Task D

This README provides answers to the Task D questions

---

## 1. How did you test your pipelines?

The pipelines for `taskb` and `taskc` branches were tested locally using a Jenkins environment run with Docker Compose.

The setup includes:
- A custom Jenkins image defined in `Dockerfile.jenkins`
- A `docker-compose.yml` to run Jenkins locally
- A `Makefile` with commands to build, run, and manage Jenkins
- A CLI-based script `setup_pipeline_X.sh` to create jobs via Jenkins CLI


### Testing Process

```bash
# 1. Build the Jenkins Docker image
make build

# 2. Start Jenkins using Docker Compose
make up

# 3. Create and seed pipelines (taskb-pipeline, taskc-pipeline, etc.)
make seed
```

Once Jenkins is running, you can open `http://localhost:8080` to monitor the pipeline jobs (`taskb-pipeline`, `taskc-pipeline`).

Each branch ([taskb](https://github.com/LouisPouliquen/jenkins-pipelines/tree/taskb), [taskc](https://github.com/LouisPouliquen/jenkins-pipelines/tree/taskc)) includes a Jenkinsfile that defines the pipeline logic. The success of each stage and the generated artifacts (doc.tar.gz, warnings.csv) were validated manually through the Jenkins UI.

### Optional Improvement

I did not implement end-to-end automated validation of pipeline results, but it could be added by:

* Using Jenkins CLI (jenkins-cli.jar) to check build status and logs
* Polling Jenkins’ REST API for result=SUCCESS
* Verifying artifact presence programmatically

## 2. How did you test the Python code in RepoC?

The parser repository [doxygen-log-parser](https://github.com/LouisPouliquen/doxygen-log-parser) was tested both manually and through automated test suites.

###  Testing Approaches

- **Unit testing:** using `pytest`, to validate the core logic of the parser
- **Integration testing:** using **Robot Framework**, to test the parser against realistic Doxygen logs
- **Manual testing:** by running the parser against sample `doxygen.log` files and inspecting the generated `warnings.csv`

###  Example Commands

```bash
# Run unit tests
make test-py

# Run integration tests (Robot Framework)
make test-robot
```

These tests verify:

* That warnings.csv is created with the correct header: File,Line,Message
* Each parsed line from the log has exactly three fields
* Malformed lines are ignored

You can find test input files under the test_files/ directory and assertions in test_parser.py and test_parse.robot.

## What is Git LFS and why use it?

**Git LFS (Large File Storage)** is a Git extension that replaces large files such as binaries, images, and archives with lightweight pointer files inside your Git repository. The actual content of these files is stored separately on a dedicated LFS server.

Git is not optimized for managing large binary files. Storing them directly in the repository can significantly slow down operations like cloning, fetching, and checking out branches.

By using Git LFS, you keep your Git history clean and lightweight while still being able to version and manage large assets efficiently. This improves performance and makes collaboration easier.

## How to adjust this repository to support Git LFS?

Refer to the official Git LFS documentation:  
- [https://git-lfs.github.com](https://git-lfs.github.com)  
- [Man pages and command documentation](https://github.com/git-lfs/git-lfs/tree/main/docs/man)

### The Git Way
First, you must define in the .gitattributes file which files you want to track with Git LFS.
For example:

```bash
git lfs track "*.tar.gz"
```

This will automatically update or create a .gitattributes file.

If you already have binary files committed in the history or on other branches, you can convert them to Git LFS using the git lfs migrate command:

```bash
git lfs migrate import --include="*.tar.gz"
```

This will replace existing files with Git LFS pointers and rewrite the Git history.

Once that’s done, simply commit and push your changes:

```bash
git add .gitattributes
git commit -m "Enable Git LFS for tarballs"
git push origin main
```

### Alternative Approaches

If versioning binary files is not necessary, or if LFS is not supported by the hosting platform, other options include:

- Using **Jenkins `archiveArtifacts`**, which stores generated files as part of the job history without committing them to the repository

- Uploading binaries to external artifact storage, such as:
  - **GitHub Releases**
  - **Amazon S3**
  - **Google Cloud Storage**
  - **Artifactory** or **Nexus**

These alternatives help keep the Git history clean while ensuring that important artifacts are still preserved and accessible.
