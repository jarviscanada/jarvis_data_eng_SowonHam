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
specs=`lscpu`
hostname=$(hostname -f) # column 1 in host_info table

cpu_number=$(echo "$specs" | grep ^CPU\(s\): | awk '{print $2}' | xargs)
cpu_architecture=$(echo "$specs" | grep Architecture | awk '{print $2}' | xargs)
cpu_model=$(echo "$specs" | grep Model\\sname | awk '{$1=$2=""; print $0}' | xargs)
cpu_mhz=$(echo "$specs" | grep CPU\\sMHz | awk '{print $3}' | xargs)
l2_cache=$(echo "$specs" | grep L2 | awk '{print $3}' | xargs)
total_mem=$(echo "$(cat /proc/meminfo)" | grep MemTotal | awk '{print $2}' | xargs)
timestamp=$(echo "$(vmstat -t)" | awk '{print $18,$19}' | tail -n 1 | xargs)

# construct the INSERT statement



# execute the INSERT statement through psql CLI tool