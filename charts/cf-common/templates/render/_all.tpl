{{/*
Render all underlying templates
*/}}

{{- define "cf-common-0.18.1.all" -}}

{{- include "cf-common-0.18.1.controller" . -}}
{{- include "cf-common-0.18.1.service" . -}}
{{- include "cf-common-0.18.1.configmaps" . -}}
{{- include "cf-common-0.18.1.secrets" . -}}
{{- include "cf-common-0.18.1.serviceaccount" . -}}
{{- include "cf-common-0.18.1.rbac" . -}}
{{- include "cf-common-0.18.1.pvc" . -}}

{{- end -}}
