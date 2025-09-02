# builder

![Version: 2.0.0](https://img.shields.io/badge/Version-2.0.0-informational?style=flat-square)

Helm Chart for default system/root runtime Builder (onprem)

**Homepage:** <https://codefresh.io/>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| codefresh |  | <https://codefresh-io.github.io/> |

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| oci://quay.io/codefresh/charts | cf-common | 0.23.0 |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` |  |
| cleaner.image.pullPolicy | string | `"IfNotPresent"` |  |
| cleaner.image.registry | string | `"quay.io"` |  |
| cleaner.image.repository | string | `"codefresh/docker-cleaner"` |  |
| cleaner.image.tag | string | `"24.0"` |  |
| configMaps.config.data."daemon.json" | string | `"{\n  \"hosts\": [ \"unix:///var/run/docker.sock\",\n            \"tcp://0.0.0.0:{{ .Values.service.main.ports.dind.port }}\"],\n  \"storage-driver\": \"overlay2\",\n  \"tlsverify\": true,\n  \"tls\": true,\n  \"tlscacert\": \"/etc/ssl/cf/ca.pem\",\n  \"tlscert\": \"/etc/ssl/cf/cert.pem\",\n  \"tlskey\": \"/etc/ssl/cf/key.pem\",\n  \"insecure-registries\" : [ {{- range $i, $e := .Values.insecureRegistries }} {{- if $i }},{{ end }} {{ $e | quote }} {{- end }} ]\n}\n"` |  |
| configMaps.config.data.docker-cleaner | string | `"#!/bin/sh\necho \"$0 - $(date)\" | tee -a /var/log/cleaner.log\nCLEANER_IMAGE={{ include (printf \"cf-common-%s.image.name\" (index .Subcharts \"cf-common\").Chart.Version ) (dict \"image\" .Values.cleaner.image \"context\" .)  }}\ndocker pull $CLEANER_IMAGE\ndocker run --rm --name rt-cleaner -v /var/run/docker.sock:/var/run/docker.sock:rw --label io.codefresh.owner=codefresh -e GRACE_PERIOD_SECONDS=86400 --cpu-shares=10 $CLEANER_IMAGE ./docker-gc >> /var/log/cleaner.log 2>&1\n"` |  |
| configMaps.config.data.register | string | `"#!/bin/sh\nset -e\nNODE_NAME=\"$1\"\nSUBDOMAIN=\"$2\"\nNODE_ADDRESS=\"$1.$2\"\nCONSUL={{ include (printf \"cf-common-%s.classic.calculateConsulUri\" (index .Subcharts \"cf-common\").Chart.Version  ) . }}\nACCOUNT=codefresh\nROLE=builder\nPROVIDER='\n{\n  \"name\": \"kube-nodes\",\n  \"type\": \"internal\"\n}'\nSYSTEM_DATA='{\"os_name\": \"dind\"}'\nNODE_SERVICE='\n{\n  \"Node\": \"'${NODE_NAME}'\",\n  \"Address\": \"'${NODE_ADDRESS}'\",\n  \"Service\": {\n    \"Service\": \"docker-node\",\n    \"Tags\": [\n      \"dind\",\n      \"noagent\",\n      \"account_codefresh\",\n      \"type_builder\"\n    ],\n    \"Address\": \"'${NODE_ADDRESS}'\",\n    \"Port\": {{ .Values.service.main.ports.dind.port }}\n  },\n  \"Check\": {\n    \"Node\": \"\",\n    \"CheckID\": \"service:docker-node\",\n    \"Name\": \"Remote Node Check\",\n    \"Notes\": \"Check builder is up and running\",\n    \"Output\": \"Builder alive and reachable\",\n    \"Status\": \"passing\",\n    \"ServiceID\": \"docker-node\"\n  }\n}'\necho \"Registering dind node ($NODE_NAME) in consul. Configuration: ${NODE_SERVICE}\"\ncurl -X PUT -d \"${NODE_SERVICE}\" ${CONSUL}/v1/catalog/register\ncurl -X PUT -d \"${NODE_ADDRESS}\" ${CONSUL}/v1/kv/services/docker-node/${NODE_NAME}/publicAddress\ncurl -X PUT -d \"${ACCOUNT}\" ${CONSUL}/v1/kv/services/docker-node/${NODE_NAME}/account\ncurl -X PUT -d \"${ROLE}\" ${CONSUL}/v1/kv/services/docker-node/${NODE_NAME}/role\ncurl -X PUT -d \"${PROVIDER}\" ${CONSUL}/v1/kv/services/docker-node/${NODE_NAME}/systemData\ncurl -X PUT -d \"${SYSTEM_DATA}\" ${CONSUL}/v1/kv/services/docker-node/${NODE_NAME}/provider\n"` |  |
| configMaps.config.enabled | bool | `true` |  |
| container.command[0] | string | `"/bin/sh"` |  |
| container.command[1] | string | `"-c"` |  |
| container.command[2] | string | `"# Adding cleaner\ncp -L /opt/dind/docker-cleaner.sh /usr/local/bin/ && chmod +x /usr/local/bin/docker-cleaner.sh\nif [[ -n \"${DOCKER_CLEANER_CRON}\" ]]; then\n  echo \"Set /etc/crontabs/root - ${DOCKER_CLEANER_CRON} /usr/local/bin/docker-cleaner.sh\"\n  echo \"${DOCKER_CLEANER_CRON} /usr/local/bin/docker-cleaner.sh \" >> /etc/crontabs/root\n  crond\nfi\nrun.sh\n"` |  |
| container.containerSecurityContext.privileged | bool | `true` |  |
| container.env.DOCKER_CLEANER_CRON | string | `"0 0 * * *"` |  |
| container.image.pullPolicy | string | `"IfNotPresent"` |  |
| container.image.registry | string | `"docker.io"` |  |
| container.image.repository | string | `"docker"` |  |
| container.image.tag | string | `"24.0-dind"` |  |
| container.resources.limits | object | `{}` |  |
| container.resources.requests | object | `{}` |  |
| container.volumeMounts.cf-certs.path[0].mountPath | string | `"/etc/ssl/cf"` |  |
| container.volumeMounts.cf-certs.path[0].readOnly | bool | `true` |  |
| container.volumeMounts.config.path[0].mountPath | string | `"/etc/docker/daemon.json"` |  |
| container.volumeMounts.config.path[0].readOnly | bool | `true` |  |
| container.volumeMounts.config.path[0].subPath | string | `"daemon.json"` |  |
| container.volumeMounts.config.path[1].mountPath | string | `"/opt/dind/docker-cleaner.sh"` |  |
| container.volumeMounts.config.path[1].subPath | string | `"docker-cleaner"` |  |
| controller | object | `{"enabled":true,"replicas":1,"type":"statefulset"}` | --------------------------------------------------------------------------------------------------------------------- |
| global.consulHost | string | `""` |  |
| global.consulHttpPort | int | `8500` |  |
| global.consulService | string | `"consul-headless"` |  |
| global.imageRegistry | string | `""` |  |
| hpa | object | `{}` |  |
| imagePullSecrets[0] | string | `"{{ .Release.Name }}-{{ .Values.global.codefresh }}-registry"` |  |
| initContainers.register.command[0] | string | `"/bin/sh"` |  |
| initContainers.register.command[1] | string | `"-c"` |  |
| initContainers.register.command[2] | string | `"cp -L /opt/dind/register /usr/local/bin/\nchmod +x /usr/local/bin/register\n/usr/local/bin/register ${POD_NAME} {{ template \"builder.fullname\" . }}.{{ .Release.Namespace}}.svc\n"` |  |
| initContainers.register.enabled | bool | `true` |  |
| initContainers.register.env.POD_NAME.valueFrom.fieldRef.apiVersion | string | `"v1"` |  |
| initContainers.register.env.POD_NAME.valueFrom.fieldRef.fieldPath | string | `"metadata.name"` |  |
| initContainers.register.image.pullPolicy | string | `"IfNotPresent"` |  |
| initContainers.register.image.registry | string | `"quay.io"` |  |
| initContainers.register.image.repository | string | `"codefresh/curl"` |  |
| initContainers.register.image.tag | string | `"8.4.0"` |  |
| initContainers.register.volumeMounts.config.path[0].mountPath | string | `"/opt/dind/register"` |  |
| initContainers.register.volumeMounts.config.path[0].subPath | string | `"register"` |  |
| insecureRegistries | list | `[]` | --------------------------------------------------------------------------------------------------------------------- Backward compatibility with values/templates in cf-helm |
| nodeSelector | object | `{}` |  |
| pdb | object | `{}` |  |
| podAnnotations.checksum/config | string | `"{{ include (print .Template.BasePath \"/configmap.yaml\") . | sha256sum }}"` |  |
| podSecurityContext | object | `{}` |  |
| rbac.enabled | bool | `false` |  |
| service.main.clusterIP | string | `"None"` |  |
| service.main.enabled | bool | `true` |  |
| service.main.ports.dind.port | int | `1300` |  |
| service.main.ports.dind.protocol | string | `"TCP"` |  |
| service.main.type | string | `"ClusterIP"` |  |
| serviceAccount.enabled | bool | `false` |  |
| tolerations | list | `[]` |  |
| topologySpreadConstraints | list | `[]` |  |
| varLibDockerVolume.accessMode | string | `nil` |  |
| varLibDockerVolume.storageSize | string | `nil` |  |
| volumeClaimTemplates.varlibdocker.accessMode | string | `"ReadWriteOnce"` |  |
| volumeClaimTemplates.varlibdocker.mountPath | string | `"/var/lib/docker"` |  |
| volumeClaimTemplates.varlibdocker.size | string | `"100Gi"` |  |
| volumeClaimTemplates.varlibdocker.storageClass | string | `nil` |  |
| volumes.cf-certs.enabled | bool | `true` |  |
| volumes.cf-certs.nameOverride | string | `"{{ .Release.Name }}-{{ .Values.global.codefresh }}-certs-client"` |  |
| volumes.cf-certs.type | string | `"secret"` |  |
| volumes.config.enabled | bool | `true` |  |
| volumes.config.type | string | `"configMap"` |  |
| volumes.varlibdocker.enabled | bool | `false` |  |
| volumes.varlibdocker.nameOverride | string | `nil` |  |
| volumes.varlibdocker.type | string | `"pvc"` |  |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.9.1](https://github.com/norwoodj/helm-docs/releases/v1.9.1)
