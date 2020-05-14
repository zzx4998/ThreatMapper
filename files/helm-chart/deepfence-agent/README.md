### Helm Chart for Deepfence Agent in Kubernetes

- Start deepfence agent
```shell script
cd kubernetes_setup/deepfence_agent/deepfence
helm install --name deepfence-agent --set managementConsoleIp=127.0.0.1 .
```

- Delete deepfence agent
```shell script
helm delete --purge deepfence-agent
```