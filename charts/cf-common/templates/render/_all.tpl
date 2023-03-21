{{/*
Render all underlying templates
*/}}

{{- define "cf-common.v0.1.0.all" -}}

{{- include "cf-common.v0.1.0.controller" . -}}
{{- include "cf-common.v0.1.0.service" . -}}
{{- include "cf-common.v0.1.0.configmaps" . -}}
{{- include "cf-common.v0.1.0.secrets" . -}}
{{- include "cf-common.v0.1.0.serviceaccount" . -}}
{{- include "cf-common.v0.1.0.rbac" . -}}

{{- end -}}
