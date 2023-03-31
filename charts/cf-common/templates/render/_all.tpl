{{/*
Render all underlying templates
*/}}

{{- define "cf-common-0.1.2.all" -}}

{{- include "cf-common-0.1.2.controller" . -}}
{{- include "cf-common-0.1.2.service" . -}}
{{- include "cf-common-0.1.2.configmaps" . -}}
{{- include "cf-common-0.1.2.secrets" . -}}
{{- include "cf-common-0.1.2.serviceaccount" . -}}
{{- include "cf-common-0.1.2.rbac" . -}}

{{- end -}}
