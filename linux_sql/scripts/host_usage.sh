#! /bin/sh

# Usage of the script
# ./scripts/host_usage.sh psql_host psql_port db_name psql_user psql_password

# Pseudocode for `host_usage` bash script
# assign CLI arguments to variables (e.g. `psql_host=$1`)
# parse host hardware specifications using bash cmds
# Construct the INSERT statement
# Execute the INSERT statement through psql CLI tool

psql_host=$1
psql_port=$2
db_name=$3
psql_user=$4
psql_password=$5

# Check the number of arguments before running the script
if [ $# -ne 5 ]; then
  echo "Insufficient number of arguments"
  exit 1
fi

vmstat_mb=$(vmstat --unit M) # in units of MB
hostname=$(hostname -f) # hostname used to subquery a matching id

# Get the timestamp of when you are retrieving above info in UTC
timestamp=$(echo "$(vmstat -t)" | awk '{print $18,$19}' | tail -n 1 | xargs)
memory_free=$(echo "$vmstat_mb" | awk '{print $4}' | tail -n 1 | xargs)
cpu_idle=$(echo "$vmstat_mb" | awk '{print $15}' | tail -n 1 | xargs)
cpu_kernel=$(echo "$vmstat_mb" | awk '{print $14}' | tail -n 1 | xargs)
disk_io=$(echo "$(vmstat -d)" | awk '{print $10}' | tail -n 1 | xargs)
disk_available=$(echo "$(df -BM)" | grep /dev/sda2 | awk '{print $4}' | sed s/.$// | xargs)

# Subquery to find matching id in host_info table
host_id="(SELECT id
FROM host_info
WHERE hostname='$hostname')";

# INSERT the server usage data into the PSQL host_usage table
insert_stmt="INSERT INTO host_usage
VALUES('$timestamp', $host_id, $memory_free, $cpu_idle, $cpu_kernel, $disk_io, $disk_available)";

# Set up the environmental variable PSQL password
export PGPASSWORD=$psql_password

# Insert the data into the database
psql -h $psql_host -p $psql_port -d $db_name -U $psql_user -c "$insert_stmt"

exit $?