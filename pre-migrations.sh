sed -i "s:\$MARIADB_USER:$MARIADB_USER:g" docker-entrypoint-initdb.d/*.sql
sed -i "s:\$MARIADB_PASSWORD:$MARIADB_PASSWORD:g" docker-entrypoint-initdb.d/*.sql
