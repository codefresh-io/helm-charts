{{/*
Render all underlying templates
*/}}

{{- define "cf-common-0.3.0.all" -}}

{{- include "cf-common-0.3.0.controller" . -}}
{{- include "cf-common-0.3.0.service" . -}}
{{- include "cf-common-0.3.0.configmaps" . -}}
{{- include "cf-common-0.3.0.secrets" . -}}
{{- include "cf-common-0.3.0.serviceaccount" . -}}
{{- include "cf-common-0.3.0.rbac" . -}}

{{- end -}}
