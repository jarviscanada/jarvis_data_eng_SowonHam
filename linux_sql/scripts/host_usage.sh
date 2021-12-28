#! /bin/sh

# Usage of the script
# ./scripts/host_info.sh psql_host psql_port db_name psql_user psql_password

# assign CLI arguments to variables (e.g. `psql_host=$1`)
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

# parse host hardware specifications using bash cmds
vmstat_mb=$(vmstat --unit M) # in units of MB
hostname=$(hostname -f) # hostname used to subquery a matching id

# Get the timestamp of when you are retrieving above info in UTC
timestamp=$(echo "$(vmstat -t)" | awk '{print $18,$19}' | tail -n 1 | xargs)
memory_free=$(echo "$vmstat_mb" | awk '{print $4}' | tail -n 1 | xargs)
cpu_idle=$(echo "$vmstat_mb" | awk '{print $15}' | tail -n 1 | xargs)
cpu_kernel=$(echo "$vmstat_mb" | awk '{print $14}' | tail -n 1 | xargs)
disk_io=$(echo "$(vmstat -d)" | awk '{print $10}' | tail -n 1 | xargs)
disk_available=$(echo "$(df -BM)" | grep /dev/sda2 | awk '{print $4}' | xargs)

# construct the INSERT statement
# Subquery to find matching id in host_info table
host_id="(SELECT id
FROM host_info
WHERE hostname='$hostname')";

# execute the INSERT statement through psql CLI tool