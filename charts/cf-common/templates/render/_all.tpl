{{/*
Render all underlying templates
*/}}

{{- define "cf-common.all" -}}

{{- include "cf-common.controller" . -}}
{{- include "cf-common.service" . -}}
{{- include "cf-common.configmaps" . -}}
{{- include "cf-common.secrets" . -}}
{{- include "cf-common.serviceaccount" . -}}
{{- include "cf-common.rbac" . -}}

{{- end -}}
