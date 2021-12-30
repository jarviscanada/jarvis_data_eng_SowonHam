#! /bin/sh

# Usage of the script
# ./scripts/host_info.sh psql_host psql_port db_name psql_user psql_password

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

specs=`lscpu`
hostname=$(hostname -f) # column 1 in host_info table


cpu_number=$(echo "$specs" | grep ^CPU\(s\): | awk '{print $2}' | xargs)
cpu_architecture=$(echo "$specs" | grep Architecture | awk '{print $2}' | xargs)
cpu_model=$(echo "$specs" | grep Model\\sname | awk '{$1=$2=""; print $0}' | xargs)
cpu_mhz=$(echo "$specs" | grep CPU\\sMHz | awk '{print $3}' | xargs)
l2_cache=$(echo "$specs" | grep L2 | awk '{print $3}' | xargs)
total_mem=$(echo "$(cat /proc/meminfo)" | grep MemTotal | awk '{print $2}' | xargs)
timestamp=$(echo "$(vmstat -t)" | awk '{print $18,$19}' | tail -n 1 | xargs)

# Get the host ID by checking the current `host_info` table
# 1. If empty then it is going to be ID 1
# 2. Check the last ID # in the table and the new info will be (last ID# + 1)
last_host_id="(SELECT id
FROM host_info
ORDER BY id DESC
LIMIT 1);";

host_id=$(($last_host_id + 1))

# INSERT the server usage data into the PSQL host_usage table
insert_stmt="INSERT INTO host_info
VALUES('$host_id', '$hostname', '$cpu_number', '$cpu_architecture', '$cpu_model', '$cpu_mhz', '$l2_cache',
'$total_mem', '$timestamp');";


# Set up the environmental variable PSQL password
export PGPASSWORD=$psql_password

# Insert the data into the database
psql -h $psql_host -p $psql_port -d $db_name -U $psql_user -c "$insert_stmt"

exit $?