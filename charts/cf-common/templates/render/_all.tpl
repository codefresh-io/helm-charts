{{/*
Render all underlying templates
*/}}

{{- define "cf-common-0.9.3.all" -}}

{{- include "cf-common-0.9.3.controller" . -}}
{{- include "cf-common-0.9.3.service" . -}}
{{- include "cf-common-0.9.3.configmaps" . -}}
{{- include "cf-common-0.9.3.secrets" . -}}
{{- include "cf-common-0.9.3.serviceaccount" . -}}
{{- include "cf-common-0.9.3.rbac" . -}}
{{- include "cf-common-0.9.3.pvc" . -}}

{{- end -}}
