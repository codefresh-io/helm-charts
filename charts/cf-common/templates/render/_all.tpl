{{/*
Render all underlying templates
*/}}

{{- define "cf-common.v0.0.25.all" -}}

{{- include "cf-common.v0.0.25.controller" . -}}
{{- include "cf-common.v0.0.25.service" . -}}
{{- include "cf-common.v0.0.25.configmaps" . -}}
{{- include "cf-common.v0.0.25.secrets" . -}}
{{- include "cf-common.v0.0.25.serviceaccount" . -}}
{{- include "cf-common.v0.0.25.rbac" . -}}

{{- end -}}
