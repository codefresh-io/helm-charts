{{/*
Calculate RabbitMQ URI (for On-Prem)
Must me called from chart root context.
Usage:
{{ include "cf-common-0.5.1.classic.calculateRabbitMqUri" . }}
*/}}

{{- define "cf-common-0.5.1.classic.calculateRabbitMqUri" }}

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
{{ include "cf.common-0.5.1.classic.calculateMongoUri" (dict "dbName" $.Values.global.pipelineManagerService "mongoURI" $.Values.global.mongoURI) }}
*/}}
{{- define "cf-common-0.5.1.classic.calculateMongoUri" -}}
  {{- if contains "?" .mongoURI -}}
    {{- $mongoURI :=  (splitList "?" .mongoURI) -}}
    {{- printf "%s%s?%s" (first $mongoURI) .dbName (last $mongoURI) }}
  {{- else -}}
    {{- printf "%s/%s" .mongoURI .dbName -}}
  {{- end -}}
{{- end -}}
