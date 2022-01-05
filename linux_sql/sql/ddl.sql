-- We can assume that the database is already created for us in this DDL
/*
 The below is the outline of the code in pseudo form:
 1. (optional) switch to `host_agent`
 2. create `host_info` table if not exist
 3. create `host_usage` table if not exist
 */

-- Connect to 'host_agent' database
\connect host_agent

-- Create a table named `host_info` if it does not exist
CREATE TABLE IF NOT EXISTS PUBLIC.host_info
(
    id SERIAL NOT NULL,
    hostname VARCHAR UNIQUE NOT NULL,
    cpu_number INTEGER NOT NULL,
    cpu_architecture VARCHAR NOT NULL,
    cpu_model VARCHAR NOT NULL,
    cpu_mhz REAL NOT NULL,
    L2_cache INTEGER NOT NULL,
    total_mem INTEGER NOT NULL,
    "timestamp" TIMESTAMP NOT NULL,
    PRIMARY KEY(id)
);

CREATE TABLE IF NOT EXISTS PUBLIC.host_usage
(
    "timestamp" TIMESTAMP NOT NULL,
    host_id SERIAL NOT NULL,
    memory_free INTEGER NOT NULL,
    cpu_idle INTEGER NOT NULL,
    cpu_kernel INTEGER NOT NULL,
    disk_io INTEGER NOT NULL,
    disk_available INTEGER NOT NULL,
    FOREIGN KEY(host_id) REFERENCES host_info(id)
);