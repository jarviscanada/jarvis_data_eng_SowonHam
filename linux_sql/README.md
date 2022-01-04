# Linux Cluster Monitoring Agent
This project is under development. Since this project follows the itFlow, the final work will be merged to the master branch after Team Code Team.

Note: You are NOT allowed to copy any content from the scrum board, including text, diagrams, code, etc. Your Github will be visible and shared with Jarvis clients, so you have to create unique content that impresses your future boss.

# Introduction
We are interested in building a Minimum Viable Product (MVP) for
the Jarvis Linux Cluster Administration (LCA) team to record and
track their server's hardware specification and resource usage. 

The Jarvis LCA team will be using the database to answer business
questions and analyze each of the nodes and decide the future
resource planning. This will allow the LCA team to make decisions
more accurately with statistical evidence. 

The hardware specifications and resource usage for each of the
nodes will be recorded in a Relational Database Management System
(RDBMS).

The RDBMS that is used in this project is PostgreSQL and the
database server is set up in a container through Docker. 

To collect the hardware specification and the resource usage
of each node, Bash scripting is performed on every instance
to saturate the database. The collection of the resource usage
of each node will be automated through CRONTAB every 1 minute interval.

The communication method of all implementations or any updates
regarding the project will be done through Git and GitHub.


# Quick Start
- Start a psql instance using psql_docker.sh
```shell
# To initially create a PSQL container
bash ./scripts/psql_docker.sh create db_username db_password
# To start/stop the PSQL container
bash ./scripts/psql_docker.sh start|stop
```

- Create tables using ddl.sql
```shell
psql -h localhost -U postgres -d host_agent -f sql/ddl.sql
```

- Insert hardware specifications data into the DB using host_info.sh
```shell
bash ./scripts/host_info.sh psql_hostname psql_port db_name psql_user psql_password
```

- Insert hardware usage data into the DB using host_usage.sh
```shell
bash ./scripts/host_usage.sh psql_hostname psql_port db_name psql_user psql_password
```

- Crontab setup
```shell
crontab -e
* * * * * bash $(pwd)/scripts/host_usage.sh psql_hostname psql_port db_name psql_user psql_password
```

# Implemenation
Discuss how you implement the project.
## Architecture
Draw a cluster diagram with three Linux hosts, a DB, and agents (use draw.io website). Image must be saved to the `assets` directory.
![](assets/cluster_diagram.drawio.png)

## Scripts
Shell script description and usage (use markdown code block for script usage)
- psql_docker.sh
- host_info.sh
- host_usage.sh
- crontab
- queries.sql (describe what business problem you are trying to resolve)

## Database Modeling
Describe the schema of each table using markdown table syntax (do not put any sql code)
- `host_info`
- `host_usage`

# Test
How did you test your bash scripts and SQL queries? What was the result?

# Deployment
How did you deploy your app? (e.g. Github, crontab, docker)

# Improvements
Write at least three things you want to improve 
e.g. 
- handle hardware update 
- blah
- blah
