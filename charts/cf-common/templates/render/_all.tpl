{{/*
Render all underlying templates
*/}}

{{- define "cf-common.v0.0.24.all" -}}

{{- include "cf-common.v0.0.24.controller" . -}}
{{- include "cf-common.v0.0.24.service" . -}}
{{- include "cf-common.v0.0.24.configmaps" . -}}
{{- include "cf-common.v0.0.24.secrets" . -}}
{{- include "cf-common.v0.0.24.serviceaccount" . -}}
{{- include "cf-common.v0.0.24.rbac" . -}}

{{- end -}}
