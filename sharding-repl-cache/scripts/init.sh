#!/bin/bash

# Wait for mongo instances to be available
sleep 10;

# Инициализируйте сервер конфигурации:
docker compose exec -T configSrv mongosh --port 27017 <<EOF
rs.initiate(
  {
    _id : "config_server",
       configsvr: true,
    members: [
      {_id: 0, host: "configSrv:27017"}
    ]
  }
);
EOF

# Инициализируйте шард 1:
docker compose exec -T shard1 mongosh --port 27018 <<EOF
rs.initiate(
    {
      _id : "shard1",
      members: [
        {_id: 0, host: "shard1:27018"},
        {_id: 1, host: "shard1-secondary-1:27021"},
        {_id: 2, host: "shard1-secondary-2:27022"},
      ]
    }
);
EOF

# Инициализируйте шард 2:
docker compose exec -T shard2 mongosh --port 27019 <<EOF
rs.initiate(
    {
      _id : "shard2",
      members: [
        {_id: 0, host : "shard2:27019"},
        {_id: 1, host: "shard2-secondary-1:27023"},
        {_id: 2, host: "shard2-secondary-2:27024"},
      ]
    }
);
EOF

# Инициализируйте роутер:
docker compose exec -T mongos_router mongosh --port 27020 <<EOF
sh.addShard( "shard1/shard1:27018,shard1-secondary-1:27021,shard1-secondary-2:27022");
sh.addShard( "shard1/shard1:27019,shard1-secondary-1:27023,shard1-secondary-2:27024");

sh.enableSharding("somedb");
sh.shardCollection("somedb.helloDoc", { "name" : "hashed" } )
EOF
