{{/*
Renders HorizontalPodAutoscaler template
Usage:
{{- include "cf-common.hpa" . -}}
*/}}

{{- define "cf-common.hpa" -}}

{{- if .Values.hpa.enabled -}}

{{ include "cf-common.controller.type" . }}

apiVersion: autoscaling/v2beta2
kind: HorizontalPodAutoscaler
metadata:
  name: {{ include "cf-common.names.fullname" . }}
  labels: {{ include "cf-common.labels.standard" . | nindent 4 }}
spec:
  scaleTargetRef:
    {{- if eq .Values.controller.type "deployment" }}
    apiVersion: apps/v1
    kind: Deployment
    {{- else if eq .Values.controller.type "rollout" }}
    apiVersion: argoproj.io/v1alpha1
    kind: Rollout
    {{- end }}
    name: {{ include "cf-common.names.fullname" . }}
  minReplicas: {{ required "hpa.minReplicas is required!" .Values.hpa.minReplicas | int }}
  maxReplicas: {{ required "hpa.maxReplicas is required!" .Values.hpa.maxReplicas | int }}
  metrics:
{{- if .Values.hpa.metrics }}
{{ toYaml .Values.hpa.metrics | indent 4 }}
{{- else if (or .Values.hpa.targetMemoryUtilizationPercentage .Values.hpa.targetCPUUtilizationPercentage) }}
{{- with .Values.hpa.targetMemoryUtilizationPercentage }}
    - type: Resource
      resource:
        name: memory
        target:
          type: Utilization
          averageUtilization: {{ . | int }}
{{- end }}
{{- with .Values.hpa.targetCPUUtilizationPercentage }}
    - type: Resource
      resource:
        name: cpu
        target:
          type: Utilization
          averageUtilization: {{ . | int }}
{{- end }}
{{- else }}
  {{- fail (printf "ERROR: hpa.targetMemoryUtilizationPercentage or hpa.targetCPUUtilizationPercentage is required!" ) }}
{{- end }}

{{- end -}}

{{- end -}}
