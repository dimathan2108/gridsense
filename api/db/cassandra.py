import os
from cassandra.cluster import Cluster

_session = None

def get_cassandra_session():
    global _session
    if _session is None:
        host = os.getenv("CASSANDRA_HOST", "timeseries-db")
        keyspace = os.getenv("CASSANDRA_KEYSPACE", "gridsense")
        cluster = Cluster([host])
        _session = cluster.connect(keyspace)
    return _session
