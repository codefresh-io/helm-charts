{{- define "cf-common.controller.analysis-template" -}}

{{- $fullName:= include "cf-common.names.fullname" . }}

---
apiVersion: argoproj.io/v1alpha1
kind: AnalysisTemplate
metadata:
  name: error-rate-{{ $fullName }}
spec:
  args: 
    - name: application-name
      value: {{ $fullName }}
  {{- with .Values.global.controller.rollout.analysisTemplate }}
  metrics: {{- .metrics | toYaml | nindent 4 }}
  {{- end }}

{{- end }}