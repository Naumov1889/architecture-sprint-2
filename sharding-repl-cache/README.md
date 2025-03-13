# Задание 3. Репликация

## Запустите контейнеры

```bash
docker compose up -d
```

## Инициализация всего, что связано с mongo

```bash
chmod +x ./scripts/init.sh
./scripts/init.sh
```

## Наполнение данными

```bash
chmod +x ./scripts/populate.sh
./scripts/populate.sh
```

## Сделайте проверку на общее количество документов в базе

```bash
docker compose exec -T mongos_router mongosh --port 27020 <<EOF
use somedb
db.helloDoc.countDocuments()
EOF
```

## Сделайте проверку на шарде 1

```bash
docker compose exec -T shard1 mongosh --port 27018 <<EOF
use somedb
db.helloDoc.countDocuments();
EOF
```

## Сделайте проверку на реплике-1 шарда 1

```bash
docker compose exec -T shard1-secondary-1 mongosh --port 27021 <<EOF
use somedb
db.helloDoc.countDocuments();
EOF
```

## Сделайте проверку на шарде 2

```bash
docker compose exec -T shard2 mongosh --port 27019 <<EOF
use somedb
db.helloDoc.countDocuments();
EOF
```

## Сделайте проверку кеширования

<http://localhost:8080/helloDoc/users>
