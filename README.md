# Task C – Jenkins Pipeline for Doxygen Generation

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
- Run the parser on the generated `doxygen.log`
- Output a structured `warnings.csv` file
- Archive both `doc.tar.gz` and `warnings.csv`


## 🐳 Jenkins Environment

This pipeline uses the same Docker-based Jenkins setup as Task B. See Task B for instructions on:

- How to build and run Jenkins (`make up`)
- How to seed a new pipeline job (`make seed`)


## 🧪 Pipeline Stages

| Stage                     | Description                                                      |
|---------------------------|------------------------------------------------------------------|
| Clone RepoA               | Clone the forked C/C++ repo (e.g. `grpc`)                        |
| Configure Doxygen         | Add `WARN_LOGFILE = doxygen.log` to `Doxyfile`                  |
| Run Doxygen               | Generate `html/` output and `doxygen.log`                       |
| Clone RepoC               | Clone your parser project                                        |
| Install Parser Deps       | Run `pip install -r requirements.txt` if present                |
| Run Parser                | Execute the Python script to convert `doxygen.log` → `warnings.csv` |
| Archive Artifacts         | Archive `doc.tar.gz` and `warnings.csv`                         |


## ✅ Makefile Targets

| Target        | Description                             |
|---------------|-----------------------------------------|
| `make build`  | Build the custom Jenkins image          |
| `make up`     | Start Jenkins via Docker Compose        |
| `make down`   | Stop and remove Jenkins container       |
| `make logs`   | Tail Jenkins logs                       |
| `make cli`    | Download `jenkins-cli.jar`              |
| `make seed`   | Seed the job using `setup_pipeline_c.sh` |
| `make reset`  | Delete volumes, reset everything        |