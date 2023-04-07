{{/*
Renders statefulset template
Must be called from chart root context.
Usage:
{{ include "cf-common-0.5.1.controller.statefulset" . }}
*/}}

{{- define "cf-common-0.5.1.controller.statefulset" -}}

{{- $strategy := "RollingUpdate"  -}}
{{- if .Values.controller.statefulset -}}
  {{- if .Values.controller.statefulset.strategy -}}
    {{- $strategy = .Values.controller.statefulset.strategy  -}}
  {{- end -}}
{{- end -}}

{{- if and (ne $strategy "OnDelete") (ne $strategy "RollingUpdate") -}}
  {{- fail (printf "ERROR: %s is invalid Stateful Set strategy!" $strategy) -}}
{{- end -}}

{{- $stsName := include "cf-common-0.5.1.names.fullname" . -}}
{{- if and (hasKey .Values.controller "nameOverride") .Values.controller.nameOverride -}}
  {{- $stsName = printf "%v-%v" $stsName .Values.controller.nameOverride -}}
{{- end -}}

---
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: {{ $stsName }}
  labels: {{ include "cf-common-0.5.1.labels.standard" . | nindent 4 }}
  {{- if .Values.controller.labels }}
  {{- include "cf-common-0.5.1.tplrender" (dict "Values" .Values.controller.labels "context" $) | nindent 4 }}
  {{- end }}
  {{- if .Values.controller.annotations }}
  annotations:
  {{- include "cf-common-0.5.1.tplrender" (dict "Values" .Values.controller.annotations "context" $) | nindent 4 }}
  {{- end }}
spec:
  revisionHistoryLimit: {{ .Values.controller.revisionHistoryLimit | int | default 5 }}
  replicas: {{ coalesce .Values.controller.replicas .Values.replicaCount | int | default 1 }}
  podManagementPolicy: {{ default "OrderedReady" .Values.controller.podManagementPolicy }}
  selector:
    matchLabels: {{ include "cf-common-0.5.1.labels.matchLabels" . | nindent 6 }}
  updateStrategy:
    type: {{ $strategy }}
    {{- if .Values.controller.statefulset }}
      {{- with .Values.controller.statefulset.rollingUpdate }}
        {{- if and (eq $strategy "RollingUpdate") .partition }}
    rollingUpdate:
      partition: {{ .partition }}
        {{- end }}
      {{- end }}
    {{- end }}
  template:
    metadata:
      labels: {{ include "cf-common-0.5.1.labels.matchLabels" . | nindent 8 }}
      {{- if .Values.podLabels }}
      {{- include "cf-common-0.5.1.tplrender" (dict "Values" .Values.podLabels "context" $) | nindent 8 }}
      {{- end }}
      {{- if .Values.podAnnotations }}
      annotations:
      {{- include "cf-common-0.5.1.tplrender" (dict "Values" .Values.podAnnotations "context" $) | nindent 8 }}
      {{- end }}
    spec: {{- include "cf-common-0.5.1.controller.pod" . | trim | nindent 6 }}
  volumeClaimTemplates:
  {{- range $claimIndex, $claimItem := .Values.volumeClaimTemplates }}
    - metadata:
        name: {{ $claimItem.name }}
        {{- with ($claimItem.labels | default dict) }}
        labels: {{- include "cf-common-0.5.1.tplrender" (dict "Values" . "context" $) | nindent 10 }}
        {{- end }}
        {{- with ($claimItem.annotations | default dict) }}
        annotations: {{- include "cf-common-0.5.1.tplrender" (dict "Values" . "context" $) | nindent 10 }}
        {{- end }}
      spec:
        {{- $claimSize := required (printf "size is required for PVC %v" $claimItem.name) $claimItem.size }}
        accessModes:
          - {{ required (printf "accessMode is required for volumeClaimTemplate %v" $claimItem.name) $claimItem.accessMode  | quote }}
        resources:
          requests:
            storage: {{ $claimSize | quote }}
        {{ include "cf-common-0.5.1.storageclass" ( dict "persistence" $claimItem "context" $) }}
    {{- end }}
{{- end -}}
