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
MONGODB_HOST env var secret name
*/}}
{{- define "cf-common-0.12.0.classic.mongodb-host-env-var-secret-name" }}
  {{- if or .Values.mongodbHost .Values.global.mongodbHost }}
{{- printf "%s-%s" (include "cf-common-0.12.0.names.fullname" .) "secret" }}
  {{- else if or .Values.mongodbHostSecretKeyRef .Values.global.mongodbHostSecretKeyRef }}
{{- printf (coalesce .Values.mongodbHostSecretKeyRef.name .Values.global.mongodbHostSecretKeyRef.name) }}
  {{- end }}
{{- end }}

{{- /*
MONGODB_HOST env var secret key
*/}}
{{- define "cf-common-0.12.0.classic.mongodb-host-env-var-secret-key" }}
  {{- if or .Values.mongodbHost .Values.global.mongodbHost }}
{{- printf "%s" "MONGODB_HOST" }}
  {{- else if or .Values.mongodbHostSecretKeyRef .Values.global.mongodbHostSecretKeyRef }}
{{- printf (coalesce .Values.mongodbHostSecretKeyRef.key .Values.global.mongodbHostSecretKeyRef.key) }}
  {{- end }}
{{- end }}

{{- /*
MONGODB_USER env var secret name
*/}}
{{- define "cf-common-0.12.0.classic.mongodb-user-env-var-secret-name" }}
  {{- if or .Values.mongodbUser .Values.global.mongodbUser }}
{{- printf "%s-%s" (include "cf-common-0.12.0.names.fullname" .) "secret" }}
  {{- else if or .Values.mongodbUserSecretKeyRef .Values.global.mongodbUserSecretKeyRef }}
{{- printf (coalesce .Values.mongodbUserSecretKeyRef.name .Values.global.mongodbUserSecretKeyRef.name) }}
  {{- end }}
{{- end }}

{{- /*
MONGODB_USER env var secret key
*/}}
{{- define "cf-common-0.12.0.classic.mongodb-user-env-var-secret-key" }}
  {{- if or .Values.mongodbUser .Values.global.mongodbUser }}
{{- printf "%s" "MONGODB_USER" }}
  {{- else if or .Values.mongodbUserSecretKeyRef .Values.global.mongodbUserSecretKeyRef }}
{{- printf (coalesce .Values.mongodbUserSecretKeyRef.key .Values.global.mongodbUserSecretKeyRef.key) }}
  {{- end }}
{{- end }}

{{- /*
MONGODB_PASSWORD env var secret name
*/}}
{{- define "cf-common-0.12.0.classic.mongodb-password-env-var-secret-name" }}
  {{- if or .Values.mongodbPassword .Values.global.mongodbPassword }}
{{- printf "%s-%s" (include "cf-common-0.12.0.names.fullname" .) "secret" }}
  {{- else if or .Values.mongodbPasswordSecretKeyRef .Values.global.mongodbPasswordSecretKeyRef }}
{{- printf (coalesce .Values.mongodbPasswordSecretKeyRef.name .Values.global.mongodbPasswordSecretKeyRef.name) }}
  {{- end }}
{{- end }}

{{- /*
MONGODB_PASSWORD env var secret key
*/}}
{{- define "cf-common-0.12.0.classic.mongodb-password-env-var-secret-key" }}
  {{- if or .Values.mongodbPassword .Values.global.mongodbPassword }}
{{- printf "%s" "MONGODB_PASSWORD" }}
  {{- else if or .Values.mongodbPasswordSecretKeyRef .Values.global.mongodbPasswordSecretKeyRef }}
{{- printf (coalesce .Values.mongodbPasswordSecretKeyRef.key .Values.global.mongodbPasswordSecretKeyRef.key) }}
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
{{- print "$(MONGO_URI)" }}
{{- /*
New secret implementation
*/}}
  {{- else }}
{{- print "$(MONGODB_PROTOCOL)://$(MONGODB_USER):$(MONGODB_PASSWORD)@$(MONGODB_HOST)/$(MONGODB_DATABASE)?$(MONGODB_OPTIONS)" }}
  {{- end }}
{{- end }}
