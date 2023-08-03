{{/*
Calculate RabbitMQ URI (for On-Prem)
Must me called from chart root context.
Usage:
{{ include "cf-common-0.12.0.classic.calculateRabbitMqUri" . }}
*/}}

{{- define "cf-common-0.12.0.classic.calculateRabbitMqUri" }}

{{- $rabbitmqProtocol := .Values.global.rabbitmqProtocol | default "amqp" -}}
{{- $rabbitmqUsername := .Values.global.rabbitmqUsername -}}
{{- $rabbitmqPassword := .Values.global.rabbitmqPassword -}}

{{- /*
coalesce here for backward compatibility
*/}}
{{- $rabbitmqHostname := .Values.global.rabbitmqHostname | default (printf "%s-%s" .Release.Name (coalesce .Values.global.rabbitService .Values.global.rabbitmqService ) ) -}}

{{- printf "%s://%s:%s@%s" $rabbitmqProtocol $rabbitmqUsername $rabbitmqPassword $rabbitmqHostname -}}

{{- end }}

{{/*
Calculate Mongo Uri (for On-Prem)
Usage:
{{ include "cf.common-0.12.0.classic.calculateMongoUri" (dict "dbName" $.Values.global.pipelineManagerService "mongoURI" $.Values.global.mongoURI) }}
*/}}
{{- define "cf-common-0.12.0.classic.calculateMongoUri" -}}
  {{- if contains "?" .mongoURI -}}
    {{- $mongoURI :=  (splitList "?" .mongoURI) -}}
    {{- printf "%s%s?%s" (first $mongoURI) .dbName (last $mongoURI) }}
  {{- else -}}
    {{- printf "%s/%s" (trimSuffix "/" .mongoURI) .dbName -}}
  {{- end -}}
{{- end -}}

{{/*
Calculate Consul host Uri (for On-Prem)
*/}}
{{- define "cf-common-0.12.0.classic.calculateConsulUri" }}
	{{- if .Values.global.consulHost }}
	{{- printf "http://%s:%v" .Values.global.consulHost .Values.global.consulHttpPort -}}
	{{- else }}
	{{- printf "http://%s-%s.%s.svc:%v" .Release.Name .Values.global.consulService .Release.Namespace .Values.global.consulHttpPort }}
	{{- end }}
{{- end }}

{{- /*
MONGODB_HOST env var value
*/}}
{{- define "cf-common-0.12.0.classic.mongodb-host-env-var-value" }}
  {{- if or .Values.global.mongodbHost .Values.mongodbHost }}
valueFrom:
  secretKeyRef:
    name: {{ printf "%s-%s" (include "cf-common-0.12.0.names.fullname" .) "secret" }}
    key: MONGODB_HOST
  {{- else if .Values.global.mongodbHostSecretKeyRef }}
valueFrom:
  secretKeyRef:
    {{- .Values.global.mongodbHostSecretKeyRef | toYaml | nindent 4 }}
  {{- end }}
{{- end }}

{{- /*
MONGO_URI env var value
*/}}
{{- define "cf-common-0.12.0.classic.mongo-uri-env-var-value" }}
{{- /*
Check for legacy global.mongoURI
*/}}
  {{- if .Values.global.mongoURI }}
{{- print (ternary (include (printf "cf-common-0.12.0.classic.calculateMongoUri" (index .Subcharts "cf-common").Chart.Version) (dict "dbName" .Values.global.mongodbDatabase "mongoURI" .Values.global.mongoURI )) .Values.global.mongoURI .Values.global.onprem ) }}
{{- /*
New secret implementation
*/}}
  {{- else }}
{{- print "$(MONGODB_PROTOCOL)://$(MONGODB_USER):$(MONGODB_PASSWORD)@$(MONGODB_HOST)?$(MONGODB_OPTIONS)" }}
  {{- end }}
{{- end }}
