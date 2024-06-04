{{/*
Render all underlying templates
*/}}

{{- define "cf-common-0.19.1.all" -}}

{{- include "cf-common-0.19.1.controller" . -}}
{{- include "cf-common-0.19.1.service" . -}}
{{- include "cf-common-0.19.1.configmaps" . -}}
{{- include "cf-common-0.19.1.secrets" . -}}
{{- include "cf-common-0.19.1.serviceaccount" . -}}
{{- include "cf-common-0.19.1.rbac" . -}}
{{- include "cf-common-0.19.1.pvc" . -}}

{{- end -}}
