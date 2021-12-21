#! /bin/sh

# Get all of the CLI arguments from client, i.e. which command, psql username, psql password resp.
cmd=$1
db_username=$2
db_password=$3

# Start docker
sudo systemctl status docker || systemctl start docker

# Check the container status
docker container inspect jrvs-psql
# Check if the command that was executed above went successfully;
# 1. If container status is 0 then above command was successful
# 2. If container status != 0 then above command did not execute successfully
container_status=$?

# User switch case to handle create|stop|start options
case $cmd in
  create)

  # Check if the container is already created
  # Precisely, after inspecting the container and container_status==0 then
  # the inspect command was successful - hence there already exists a container
  if [ $container_status -eq 0 ]; then
		echo 'Container already exists'
		exit 1
	fi

  # Check the number of CLI arguments
  # If the number of CLI arguments is NOT EQUAL to 3
  if [ $# -ne 3 ]; then
    echo 'Create requires username and password'
    exit 1
  fi

  #Create container
	docker volume create pgdata
	docker run --name jrvs-psql -e POSTGRES_PASSWORD=$db_password -d -v pgdata:/var/lib/postgresql/data -p 5432:5432 postgres:9.6-alpine

	exit $?
	;; # end of the case 1 statement

  start|stop)
  # Check instance status; exit 1 if container has not been created
  if [ $container_status -eq 1 ]; then
    echo "Container does not exist"
    exit 1
  fi

  # Start or stop the container based on the given CLI argument $1
	docker container $cmd jrvs-psql
	exit $?
	;; # end of the case 2 statement

  *) # for any CLI argument for $cmd(equivalently $1) output the following error message
	echo 'Illegal command'
	echo 'Commands: start|stop|create'
	exit 1
	;; # end of the case 4 statement
esac