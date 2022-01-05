-- 1. Group hosts by hardware info
-- Group hosts by CPU number and sort by their memory size in descending order(within each cpu_number group)
SELECT cpu_number, id, total_mem
FROM host_info
ORDER BY cpu_number ASC, total_mem DESC;

-- Note: When you are inserting data points into the host_info table
-- and the first column usually takes an ID and since this is a SERIAL data type
-- and we pass a DEFAULT argument, it is not necessarily going to be in order...
-- PSQL does not use a "gapless sequencing" meaning there will be potentially gaps in between the numbers.
-- This should not affect the database in any way, anyways.

-- 2. Average memory usage
-- Average used memory in percentage over 5 mins interval for each host. (used memory = total memory - free memory).

-- sample data points
INSERT INTO host_usage ("timestamp", host_id, memory_free, cpu_idle, cpu_kernel, disk_io,
                        disk_available)
VALUES ('2019-05-29 15:00:00.000', 1, 300000, 90, 4, 2, 3);
INSERT INTO host_usage ("timestamp", host_id, memory_free, cpu_idle, cpu_kernel, disk_io,
                        disk_available)
VALUES ('2019-05-29 15:01:00.000', 1, 200000, 90, 4, 2, 3);

-- Solution for #2 below
SELECT host_id, round5(host_usage.timestamp) AS "timestamp",
       AVG(used_memory_percentage(host_info.total_mem, host_usage.memory_free)) AS avg_used_memory
FROM host_usage, host_info
GROUP BY round5(host_usage.timestamp), host_id
ORDER BY "timestamp";

CREATE FUNCTION round5(ts timestamp) RETURNS timestamp AS
$$
BEGIN
    RETURN date_trunc('hour', ts) + date_part('minute', ts):: int / 5 * interval '5 min';
END
$$
    LANGUAGE PLPGSQL;

CREATE FUNCTION used_memory_percentage(total_mem INTEGER, free_memory REAL) RETURNS REAL AS
$$
BEGIN
    RETURN ((1-(free_memory/total_mem)) * 100);
END
$$
    LANGUAGE PLPGSQL;

-- 3. Detect host failure
-- The CRON job is supposed to insert a new entry to the host_usage table every minute when the server is healthy.
-- We can assume that a server is failed when it inserts less than three data points within 5-min interval.
-- Please write a query to detect host failures.

-- Solution for #3 below
SELECT host_id,
       round5(timestamp) AS "timestamp",
       COUNT(*) AS num_data_points
FROM host_usage
GROUP BY round5(host_usage.timestamp), host_id
HAVING COUNT(*) < 3
ORDER BY "timestamp";