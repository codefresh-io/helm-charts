{{/*
Calculate RabbitMQ URI
Usage:
{{ include "cf-common.classic.calculateRabbitMqUri" . }}
*/}}

{{- define "cf-common.classic.calculateRabbitMqUri" }}

{{- $rabbitmqProtocol := $.Values.global.rabbitmqProtocol | default "amqp" -}}
{{- $rabbitmqUsername := $.Values.global.rabbitmqUsername -}}
{{- $rabbitmqPassword := $.Values.global.rabbitmqPassword -}}

{{- /*
If built-in bitnami/rabbitmq chart enabled get username/password there
*/}}
{{- if $.Values.rabbitmq }}
  {{- if $.Values.rabbitmq.enabled }}
    {{- $rabbitmqUsername = $.Values.rabbitmq.auth.username -}}
    {{- $rabbitmqPassword = $.Values.rabbitmq.auth.password -}}
  {{- end }}
{{- end }}

{{- /*
coalesce here for backward compatibility
*/}}
{{- $rabbitmqHostname := $.Values.global.rabbitmqHostname | default (printf "%s-%s" .Release.Name (coalesce $.Values.global.rabbitService $.Values.global.rabbitmqService ) ) -}}

{{- printf "%s://%s:%s@%s" $rabbitmqProtocol $rabbitmqUsername $rabbitmqPassword $rabbitmqHostname -}}

{{- end }}

{{/*
Calculate Mongo Uri
Usage:
{{ include "cf.common.classic.calculateMongoUri" (dict "dbName" $.Values.global.pipelineManagerService "mongoURI" $.Values.global.mongoURI) }}
*/}}
{{- define "cf-common.classic.calculateMongoUri" -}}
  {{- if contains "?" .mongoURI -}}
    {{- $mongoURI :=  (splitList "?" .mongoURI) -}}
    {{- printf "%s%s?%s" (first $mongoURI) .dbName (last $mongoURI) }}
  {{- else -}}
    {{- printf "%s/%s" .mongoURI .dbName -}}
  {{- end -}}
{{- end -}}
