{{/*
Renders PodDisruptionBudget template
{{- include "cf-common.pdb" . -}}
*/}}

{{- define "cf-common.pdb" -}}

{{- if .Values.pdb.enabled -}}

apiVersion: policy/v1
kind: PodDisruptionBudget
metadata:
  name: {{ include "cf-common.names.fullname" . }}
  labels: {{ include "cf-common.labels.standard" . | nindent 4 }}
spec:
{{- if or .Values.pdb.minAvailable .Values.pdb.maxUnavailable }}
  {{- with .Values.pdb.minAvailable }}
  minAvailable: {{ . }}
  {{- end }}
  {{- with .Values.pdb.maxUnavailable }}
  maxUnavailable: {{ . }}
  {{- end }}
{{- else }}
  {{- fail (printf "ERROR: pdb.minAvailable or pdb.maxUnavailable is required!" ) }}
{{- end }}
  selector:
    matchLabels: {{ include "cf-common.labels.matchLabels" . | nindent 6 }}

{{- end -}}

{{- end -}}
