{{/*
Renders Extra objects defined at .Values.extraResources
Usage:
{{- include "cf-common-0.1.2.extraResources" . -}}
*/}}

{{- define "cf-common-0.1.2.extraResources" -}}

{{/* Restoring root $ context */}}
{{- $ := .context -}}

{{- range .Values.extraResources }}
{{ include "cf-common-0.1.2.tplrender" (dict "Values" . "context" $) }}
{{- end }}

{{- end -}}
