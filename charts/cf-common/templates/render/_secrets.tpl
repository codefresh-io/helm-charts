{{/*
Renders Secrets templates
{{- include "cf-common.secrets" . -}}
*/}}
{{- define "cf-common.secrets" -}}

{{- range $secretIndex, $secretItem := .Values.secrets }}

{{- if $secretItem.enabled }}
{{- $secretName := printf "%s-%s" (include "cf-common.names.fullname" $) $secretIndex }}
---
apiVersion: v1
kind: Secret
metadata:
  name: {{ $secretName }}
  labels: {{ include "cf-common.labels.standard" $ | nindent 4 }}
  {{- if $secretItem.labels }}
  {{- include "cf-common.tplrender" (dict "Values" $secretItem.labels "context" $) | nindent 4 }}
  {{- end }}
  {{- if $secretItem.annotations }}
  annotations: {{- include "cf-common.tplrender" (dict "Values" $secretItem.annotations "context" $) | nindent 4 }}
  {{- end }}
{{- with $secretItem.type }}
type: {{ . }}
{{- end }}
{{- if $secretItem.stringData }}
  {{- if not ( or (kindIs "map" $secretItem.stringData) (kindIs "string" $secretItem.stringData) ) }}
    {{- fail (printf "ERROR: secrets.%s.stringData must be a map or multiline string!" $secretIndex) }}
  {{- end }}
stringData: {{ toYaml $secretItem.data | nindent 2 }}
{{- else if $secretItem.data }}
  {{- if not (kindIs "map" $secretItem.data ) }}
    {{- fail (printf "ERROR: secrets.%s.data must be a map" $secretIndex) }}
  {{- end }}
data: {{ toYaml $secretItem.data | nindent 2 }}
{{- else }}
  {{- fail (printf "ERROR: empty data or stingData for secrets.%s!" $secretIndex) }}
{{- end }}

{{- end }}

{{- end }}

{{- end }}
