{{/*
Renders Service Monitor objects.
*/}}

{{- define "cf-common-0.9.0.serviceMonitor" -}}

{{- range $serviceMonitorIndex, $serviceMonitorItem := .Values.serviceMonitor -}}

{{- $serviceMonitorName := include "cf-common-0.9.0.names.fullname" $ -}}
{{- if and (hasKey $serviceMonitorItem "nameOverride") $serviceMonitorItem.nameOverride -}}
  {{- $serviceMonitorName = printf "%v-%v" $serviceMonitorName $serviceMonitorItem.nameOverride -}}
{{- end -}}

  {{- if $serviceMonitorItem.enabled -}}
---
apiVersion: monitoring.coreos.com/v1
kind: ServiceMonitor
metadata:
  name: {{ $serviceMonitorName }}
  labels: {{ include "cf-common-0.9.0.labels.standard" $ | nindent 4 }}
  {{- if $serviceMonitorItem.labels }}
  {{- include "cf-common-0.9.0.tplrender" (dict "Values" $serviceMonitorItem.labels "context" $) | nindent 4 }}
  {{- end }}
  {{- if $serviceMonitorItem.annotations }}
  annotations: {{- include "cf-common-0.9.0.tplrender" (dict "Values" $serviceMonitorItem.annotations "context" $) | nindent 4 }}
  {{- end }}
spec:
  selector:
    matchLabels:
    {{- if $serviceMonitorItem.selector }}
      {{- include "cf-common-0.9.0.tplrender" (dict "Values" $serviceMonitorItem.selector "context" $) | nindent 6 }}
    {{- else }}
      {{- include "cf-common-0.9.0.labels.matchLabels" $ | nindent 6 }}
    {{- end }}
  endpoints: {{- toYaml ( required (printf "endpoints are required for serviceMonitor %v" $serviceMonitorName) $serviceMonitorItem.endpoints ) | nindent 4 }}
{{- end }}
  {{- end -}}

{{- end -}}
