{{/*
Renders contoller object
Usage:
{{- include "cf-common.controller" . -}}
{{ .Values.controller | mustToPrettyJson | fail }}
*/}}

{{- define "cf-common.controller" -}}

{{- if or .Values.controller.enabled -}}
  {{- if eq .Values.global.controller.type "rollout" }}
    {{ include "cf-common.controller.rollout" . | nindent 0 }}
  {{- else if eq .Values.controller.type "rollout" }}
    {{ include "cf-common.controller.rollout" . | nindent 0 }}
  {{- else if eq .Values.controller.type "deployment" }}
    {{ include "cf-common.controller.deployment" . | nindent 0 }}
  {{- else }}
    {{ fail (printf "ERROR: %s is invalid controller type!" .Values.controller.type) }}
  {{- end }}
{{- end -}}


{{- end -}}
