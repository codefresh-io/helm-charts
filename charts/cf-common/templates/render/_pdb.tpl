{{/*
Renders PodDisruptionBudget object.
Must be called from chart root context.
{{- include "cf-common-0.12.3.pdb" . -}}
*/}}

{{- define "cf-common-0.12.3.pdb" -}}

{{- if .Values.pdb.enabled -}}

apiVersion: policy/v1
kind: PodDisruptionBudget
metadata:
  name: {{ include "cf-common-0.12.3.names.fullname" . }}
  labels: {{ include "cf-common-0.12.3.labels.standard" . | nindent 4 }}
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
    matchLabels: {{ include "cf-common-0.12.3.labels.matchLabels" . | nindent 6 }}

{{- end -}}

{{- end -}}
