{{- define "cf-common.v0.0.25.controller.analysis-template" -}}

{{- $fullName:= include "cf-common.v0.0.25.names.fullname" . }}

---
apiVersion: argoproj.io/v1alpha1
kind: AnalysisTemplate
metadata:
  name: error-rate-{{ $fullName }}
spec:
  {{- with .Values.controller.rollout.analysisTemplate }}
  args: {{- include "cf-common.v0.0.25.tplrender" (dict "Values" .args "context" $) | nindent 4 }}
  metrics: {{- .metrics | toYaml | nindent 4 }}
  {{- end }}

{{- end }}