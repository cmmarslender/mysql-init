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

mysql -h "$DB_HOST" -u "$rootUser" -p${rootPassword} --default-auth mysql_native_password -e "CREATE DATABASE IF NOT EXISTS \`$DB_NAME\`;"

mysql -h "$DB_HOST" -u "$rootUser" -p${rootPassword} --default-auth mysql_native_password -e "CREATE USER IF NOT EXISTS '$DB_USER'@'%' IDENTIFIED WITH mysql_native_password BY '$DB_PASSWORD';"

# This is in case the user previously existed, but the password has changed
mysql -h "$DB_HOST" -u "$rootUser" -p${rootPassword} --default-auth mysql_native_password -e "ALTER USER '$DB_USER'@'%' IDENTIFIED WITH mysql_native_password BY '$DB_PASSWORD';"

mysql -h "$DB_HOST" -u "$rootUser" -p${rootPassword} --default-auth mysql_native_password -e "GRANT ALL PRIVILEGES ON \`$DB_NAME\`.* TO '$DB_USER'@'%';"

mysql -h "$DB_HOST" -u "$rootUser" -p${rootPassword} --default-auth mysql_native_password -e "FLUSH PRIVILEGES;"
