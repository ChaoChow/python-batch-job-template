APP_NAME:= $(shell basename $(CURDIR))
APP_NAME_SNAKE_CASE:= $(shell echo $(APP_NAME) | tr - _)
VERSION_TAG= $(shell poetry version -s)
ECR_REPO_URL={{cookiecutter.ecr_repo_host_url}}
INPUT_FILE_NAME={{cookiecutter.instruction_file_name}}

.PHONY: test

setup:
	poetry update
	poetry install
	cd terraform && \
	terraform init

# Development Lifecycle

test:
	poetry run pytest test

format:
	poetry run black .

lint:
	poetry run ruff ${APP_NAME_SNAKE_CASE} --fix

type:
	poetry run mypy ${APP_NAME_SNAKE_CASE} test

precommit:
	make test
	make format
	make lint
	make type

# Running Locally

run:
	make aws-login
	export ENVIRONMENT=local && \
	export AWS_DEFAULT_REGION={{cookiecutter.aws_region}} && \
	export AWS_PROFILE={{cookiecutter.aws_local_profile_name}} && \
	poetry run python main.py ${INPUT_FILE_NAME}

# Version Bumping

version-major:
	poetry version major

version-minor:
	poetry version minor

version-patch:
	poetry version patch

# CICD

aws-login:
	aws sso login --profile {{cookiecutter.aws_local_profile_name}}

docker-build:
	docker build -f build/Dockerfile . -t ${APP_NAME}:${VERSION_TAG} --build-arg PACKAGE_NAME=${APP_NAME_SNAKE_CASE}

ecr-push:
	make aws-login
	aws ecr get-login-password --region us-east-1 --profile {{cookiecutter.aws_local_profile_name}} | docker login --username AWS --password-stdin ${ECR_REPO_URL}
	docker tag ${APP_NAME}:${VERSION_TAG} ${ECR_REPO_URL}/${APP_NAME}:${VERSION_TAG}
	docker push ${ECR_REPO_URL}/${APP_NAME}:${VERSION_TAG}

# Deploy

deploy:
	export TF_VAR_app_image="${ECR_REPO_URL}/${APP_NAME}:${VERSION_TAG}" && export TF_VAR_environment="prod" && \
	cd terraform && \
	terraform apply
