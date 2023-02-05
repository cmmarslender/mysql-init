# MySQL Init Container

Creates a database and user in a given database

Secret with root db creds
```yaml
kubectl create secret generic dbrootcreds \
--from-literal=rootUser="root" \
--from-literal=rootHost="%" \
--from-literal=rootPassword="password"
```

Secret with the main user creds
```
kubectl create secret generic dbusercreds \
--from-literal=DB_USER="mydbuser" \
--from-literal=DB_HOST="example-mysql-cluster" \
--from-literal=DB_PASSWORD="password" \
--from-literal=DB_NAME="mydb"
```

Creates the db cluster
```yaml
apiVersion: mysql.oracle.com/v2
kind: InnoDBCluster
metadata:
  name: example-mysql-cluster
spec:
  secretName: dbrootcreds
  tlsUseSelfSigned: true
  instances: 3
  router:
    instances: 1
```

Example deployment that uses the init container and then runs some other arbitrary service
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: example-deployment
  labels:
    app: example
spec:
  replicas: 1
  selector:
    matchLabels:
      app: example
  template:
    metadata:
      labels:
        app: example
    spec:
      initContainers:
        - name: initdb
          image: ghcr.io/cmmarslender/mysql-init
          envFrom:
            - secretRef:
                name: dbrootcreds
            - secretRef:
                name: dbusercreds
      containers:
        - name: debugger
          image: busybox
          command: ['sleep', '3600']
          envFrom:
            - secretRef:
                name: dbusercreds
```
