CREATE KEYSPACE IF NOT EXISTS gridsense
WITH replication = {
  'class': 'SimpleStrategy',
  'replication_factor': 1
};

USE gridsense;

-- Table 1: readings per sensor over time (pattern 1)
CREATE TABLE IF NOT EXISTS sensor_readings (
    sensor_id TEXT,
    reading_time TIMESTAMP,
    metric_type TEXT,
    value FLOAT,
    unit TEXT,
    quality_flag TINYINT,
    PRIMARY KEY ((sensor_id), reading_time)
) WITH CLUSTERING ORDER BY (reading_time DESC)
AND default_time_to_live = 7776000; -- 90 days

-- Table 2: relay operation log (append-only, causal order)
CREATE TABLE IF NOT EXISTS relay_events (
    feeder_id TEXT,
    event_time TIMEUUID,
    relay_id TEXT,
    event_type TEXT,
    fault_type TEXT,
    current_kA FLOAT,
    PRIMARY KEY ((feeder_id), event_time)
) WITH CLUSTERING ORDER BY (event_time ASC);

-- Table 3: dashboard query (pattern 2)
CREATE TABLE IF NOT EXISTS sensor_readings_by_time (
    time_window_start TIMESTAMP,
    reading_time TIMESTAMP,
    sensor_id TEXT,
    metric_type TEXT,
    value DOUBLE,
    unit TEXT,
    quality_flag TINYINT,
    PRIMARY KEY ((time_window_start), reading_time, sensor_id)
) WITH CLUSTERING ORDER BY (reading_time DESC, sensor_id ASC)
AND default_time_to_live = 300; -- short TTL for dashboard cache
