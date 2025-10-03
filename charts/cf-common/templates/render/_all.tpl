{{/*
Render all underlying templates
*/}}

{{- define "cf-common-0.29.0.all" -}}

{{- include "cf-common-0.29.0.controller" . -}}
{{- include "cf-common-0.29.0.service" . -}}
{{- include "cf-common-0.29.0.configmaps" . -}}
{{- include "cf-common-0.29.0.secrets" . -}}
{{- include "cf-common-0.29.0.serviceaccount" . -}}
{{- include "cf-common-0.29.0.rbac" . -}}
{{- include "cf-common-0.29.0.pvc" . -}}

{{- end -}}
