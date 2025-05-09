# Task B – Jenkins Pipeline for Doxygen Generation

This repository sets up a local Jenkins environment using Docker Compose to run a pipeline that generates Doxygen documentation for a forked C++/C project.

## 🎯 Goal

Automate the following via a Jenkins pipeline:

- Clone a forked C/C++ repository (e.g. `grpc`)
- Generate a default `Doxyfile` via `doxygen -g`
- Configure it to:
  - Use `src/` as input
  - Enable HTML output
  - Disable LaTeX output
- Run Doxygen
- Archive the HTML output as `doc.tar.gz`


## 🐳 Jenkins Environment (Local, Docker-based)

The setup uses a custom Jenkins image with:

- Preinstalled Doxygen
- Jenkins plugins installed via `plugins.txt`
- Job seed automation using `jenkins-cli.jar`


## 🚀 Usage

### 1. Build and Start Jenkins

```bash
make up
```

This will:

* Build the Jenkins image
* Start Jenkins via Docker Compose
* Expose Jenkins on `http://localhost:8080`

After Jenkins is ready:

```bash
make seed
```

This will:
* Download `jenkins-cli.jar`
* Create (or update) a job named `taskb-pipeline` from `multibranch-config.xml`



## ✅ Makefile Targets

| Target        | Description                             |
|---------------|-----------------------------------------|
| `make build`  | Build the custom Jenkins image          |
| `make up`     | Start Jenkins via Docker Compose        |
| `make down`   | Stop and remove Jenkins container       |
| `make logs`   | Tail Jenkins logs                       |
| `make cli`    | Download `jenkins-cli.jar`              |
| `make seed`   | Seed the job using `setup_pipeline_b.sh` |
| `make reset`  | Delete volumes, reset everything        |