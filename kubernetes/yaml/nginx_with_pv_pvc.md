
# Nginx Deployment in kubernetes

Includes PV and PVC to the configurations.
## Yaml Reference

To deploy this project, create a yaml file with below contents.

```bash
apiVersion: v1
kind: PersistentVolume
metadata:
  name: nginx-pv
spec:
  capacity:
    storage: 1Gi
  accessModes:
    - ReadWriteOnce
  hostPath:
    path: "/home/cloud_user/nginx-cloud/"
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: nginx-pvc
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 1Gi
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
spec:
  replicas: 3
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:latest
        volumeMounts:
        - name: nginx-storage
          mountPath: /usr/share/nginx/html
      volumes:
      - name: nginx-storage
        persistentVolumeClaim:
          claimName: nginx-pvc
---
apiVersion: v1
kind: Service
metadata:
  name: nginx-service
spec:
  selector:
    app: nginx
  ports:
    - protocol: TCP
      port: 80
      targetPort: 80
  type: NodePort
```
## Screenshots

![image](https://github.com/gtamilvanan17/devops/assets/121214873/017b7b83-f448-4a5c-b625-7bfdf1b2d264)
![image](https://github.com/gtamilvanan17/devops/assets/121214873/454f4245-f316-41dc-bb21-333d879dd24d)



## Feedback

If you have any feedback, please reach out to us at admin@tamilvanan.live

