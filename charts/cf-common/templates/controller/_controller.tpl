{{/*
Renders contoller object
Usage:
{{- include "cf-common.controller" . -}}
{{ .Values.controller | mustToPrettyJson | fail }}
*/}}

{{- define "cf-common.controller" -}}

{{- if .Values.controller.enabled -}}

  {{- $controllerDict := .Values.controller -}}
  {{- if .Values.global -}}
    {{- if .Values.global.controller -}}
      {{- $controllerDict = merge $controllerDict .Values.global.controller -}}
    {{- end -}}
  {{- end -}}
  {{- $_ := set .Values "controller" $controllerDict -}}

  {{- if eq $controllerDict.type "rollout" }}
    {{ include "cf-common.controller.rollout" . | nindent 0 }}
  {{- else if eq $controllerDict.type "deployment" }}
    {{ include "cf-common.controller.deployment" . | nindent 0 }}
  {{- else }}
    {{ fail (printf "ERROR: %s is invalid controller type!" .Values.controller.type) }}
  {{- end }}
{{- end -}}

{{- end -}}
