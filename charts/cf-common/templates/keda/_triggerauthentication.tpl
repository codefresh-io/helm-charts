{{- define "cf-common-0.20.1.keda.trigger-authentication" }}
  {{- if and .Values.keda.auth.enabled .Values.keda.enabled }}
apiVersion: keda.sh/v1alpha1
kind: TriggerAuthentication
metadata:
  name: {{ include "cf-common-0.20.1.names.fullname" . }}
  labels: {{ include "cf-common-0.20.1.labels.standard" . | nindent 4 }}
spec:
  secretTargetRef: {{ toYaml .Values.keda.auth.secretTargetRef | nindent 4 }}
  {{- end }}
{{- end }}
