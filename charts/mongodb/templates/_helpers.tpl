{{/*
Expand the name of the chart.
*/}}
{{- define "mongodb.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
*/}}
{{- define "mongodb.fullname" -}}
{{ $templateName := printf "cf-common-%s.names.fullname" (index .Subcharts "cf-common").Chart.Version }}
{{- include $templateName . -}}
{{- end -}}

{{/*
Name of the credentials secret created by cf-common secrets template.
*/}}
{{- define "mongodb.secretName" -}}
{{- printf "%s-secret" (include "mongodb.fullname" .) -}}
{{- end -}}