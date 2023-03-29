{{/*
Renders Extra objects defined at .Values.extraResources
Usage:
{{- include "cf-common-0.1.0.extraResources" . -}}
*/}}

{{- define "cf-common-0.1.0.extraResources" -}}

{{/* Restoring root $ context */}}
{{- $ := .context -}}

{{- range .Values.extraResources }}
{{ include "cf-common-0.1.0.tplrender" (dict "Values" . "context" $) }}
{{- end }}

{{- end -}}
