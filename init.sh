#!/bin/sh

# Root Information is expected in the following mysql-operator compatible keys:
# rootUser
# rootPassword
# rootHost
#
# The database that will be created, along with host, creds, etc, is expected in the following WP compatible form:
# DB_USER
# DB_PASSWORD
# DB_HOST
# DB_NAME

mysql -h "$DB_HOST" -u "$rootUser" -p${rootPassword} -e "CREATE DATABASE IF NOT EXISTS \`$DB_NAME\`;"

mysql -h "$DB_HOST" -u "$rootUser" -p${rootPassword} -e "CREATE USER IF NOT EXISTS '$DB_USER'@'%' IDENTIFIED BY '$DB_PASSWORD';"

# This is in case the user previously existed, but the password has changed
mysql -h "$DB_HOST" -u "$rootUser" -p${rootPassword} -e "ALTER USER '$DB_USER'@'%' IDENTIFIED BY '$DB_PASSWORD';"

mysql -h "$DB_HOST" -u "$rootUser" -p${rootPassword} -e "GRANT ALL PRIVILEGES ON \`$DB_NAME\`.* TO '$DB_USER'@'%';"

mysql -h "$DB_HOST" -u "$rootUser" -p${rootPassword} -e "FLUSH PRIVILEGES;"
