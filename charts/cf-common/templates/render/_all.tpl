{{/*
Render all underlying templates
*/}}

{{- define "cf-common-0.18.2.all" -}}

{{- include "cf-common-0.18.2.controller" . -}}
{{- include "cf-common-0.18.2.service" . -}}
{{- include "cf-common-0.18.2.configmaps" . -}}
{{- include "cf-common-0.18.2.secrets" . -}}
{{- include "cf-common-0.18.2.serviceaccount" . -}}
{{- include "cf-common-0.18.2.rbac" . -}}
{{- include "cf-common-0.18.2.pvc" . -}}

{{- end -}}
