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
#
# Optional Parameters
# DB_READ_ONLY_USER
# DB_READ_ONLY_PASSWORD

# Create the database
mysql -h "$DB_HOST" -u "$rootUser" -p${rootPassword} --default-auth mysql_native_password -e "CREATE DATABASE IF NOT EXISTS \`$DB_NAME\`;"

# Create the read/write user for the database
# First we create, then we update, in case the user already existed, but the password changed
mysql -h "$DB_HOST" -u "$rootUser" -p${rootPassword} --default-auth mysql_native_password -e "CREATE USER IF NOT EXISTS '$DB_USER'@'%' IDENTIFIED WITH mysql_native_password BY '$DB_PASSWORD';"
mysql -h "$DB_HOST" -u "$rootUser" -p${rootPassword} --default-auth mysql_native_password -e "ALTER USER '$DB_USER'@'%' IDENTIFIED WITH mysql_native_password BY '$DB_PASSWORD';"
mysql -h "$DB_HOST" -u "$rootUser" -p${rootPassword} --default-auth mysql_native_password -e "GRANT ALL PRIVILEGES ON \`$DB_NAME\`.* TO '$DB_USER'@'%';"

# Create the read only user for the database, if the vars are set
if [ -n "$DB_READ_ONLY_USER" ] && [ -n "$DB_READ_ONLY_PASSWORD" ]; then
  mysql -h "$DB_HOST" -u "$rootUser" -p${rootPassword} --default-auth mysql_native_password -e "CREATE USER IF NOT EXISTS '$DB_READ_ONLY_USER'@'%' IDENTIFIED WITH mysql_native_password BY '$DB_READ_ONLY_PASSWORD';"
  mysql -h "$DB_HOST" -u "$rootUser" -p${rootPassword} --default-auth mysql_native_password -e "ALTER USER '$DB_READ_ONLY_USER'@'%' IDENTIFIED WITH mysql_native_password BY '$DB_READ_ONLY_PASSWORD';"
  mysql -h "$DB_HOST" -u "$rootUser" -p${rootPassword} --default-auth mysql_native_password -e "GRANT SELECT, SHOW VIEW ON \`$DB_NAME\`.* TO '$DB_READ_ONLY_USER'@'%';"
fi

# Flush Priv
mysql -h "$DB_HOST" -u "$rootUser" -p${rootPassword} --default-auth mysql_native_password -e "FLUSH PRIVILEGES;"
