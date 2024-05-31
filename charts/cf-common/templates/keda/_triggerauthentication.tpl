{{- define "cf-common-0.19.0.keda.trigger-authentication" }}
  {{- if (index .Values "keda" "trigger-authentication" "enabled") }}
apiVersion: keda.sh/v1alpha1
kind: TriggerAuthentication
metadata:
  name: {{ include "cf-common-0.19.0.names.fullname" . }}
  labels: {{ include "cf-common-0.19.0.labels.standard" . | nindent 4 }}
spec:
  secretTargetRef: {{ toYaml (index .Values "keda" "trigger-authentication" "secretTargetRef" ) | nindent 4 }}
  {{- end }}
{{- end }}
