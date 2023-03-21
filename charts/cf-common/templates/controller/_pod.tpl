{{/*
Renders pod in controller template
Usage:
{{ include "cf-common.v0.0.24.controller.pod" . }}
*/}}
{{- define "cf-common.v0.0.24.controller.pod" -}}

{{- include "cf-common.v0.0.24.image.pullSecrets" . }}

serviceAccountName: {{ include "cf-common.v0.0.24.names.serviceAccountName" . }}

automountServiceAccountToken: {{ .Values.automountServiceAccountToken | default true }}

{{- with .Values.podSecurityContext }}
  {{- if not (kindIs "map" .) }}
    {{- fail "ERROR: podSecurityContext block must be a map!" }}
  {{- end }}
securityContext: {{ toYaml . | nindent 2 }}
{{- end }}

{{- with .Values.priorityClassName }}
priorityClassName: {{ . }}
{{- end }}

{{- with .Values.runtimeClassName }}
runtimeClassName: {{ . }}
{{- end }}

{{- with .Values.schedulerName }}
schedulerName: {{ . }}
{{- end }}

{{- with .Values.hostNetwork }}
hostNetwork: {{ . }}
{{- end }}

{{- if .Values.dnsPoliicy }}
dnsPolicy: {{ .Values.dnsPolicy }}
{{- else if .Values.hostNetwork }}
dnsPolicy: ClusterFirstWithHostNet
{{- else }}
dnsPolicy: ClusterFirst
{{- end }}

{{- with .Values.dnsConfig }}
dnsConfig: {{ toYaml . | nindent 2 }}
{{- end }}

{{- with .Values.terminationGracePeriodSeconds }}
terminationGracePeriodSeconds: {{ . }}
{{- end }}

{{- with .Values.initContainers }}
initContainers: {{- include "cf-common.v0.0.24.tplrender" (dict "Values" . "context" $) | nindent 2 }}
{{- end }}

{{- with .Values.container }}
containers: {{ include "cf-common.v0.0.24.container" (dict "Values" . "context" $) | trim | nindent 0 }}
{{- end }}
{{- with .Values.additionalContainers }}
{{ toYaml . | nindent 0 }}
{{- end }}

{{- with .Values.volumes }}
volumes:
{{ include "cf-common.v0.0.24.volumes" (dict "Values" . "context" $) | trim }}
{{- end }}

{{- with .Values.extraVolumes }}
{{ include "cf-common.v0.0.24.volumes" (dict "Values" . "context" $) | trim }}
{{- end }}

{{- with .Values.hostAliases }}
hostAliases: {{ toYaml . | nindent 2 }}
{{- end }}

{{- with .Values.nodeSelector }}
  {{- if not (kindIs "map" .) }}
    {{- fail "ERROR: nodeSelector block must be a map!" }}
  {{- end }}
nodeSelector: {{ toYaml . | nindent 2 }}
{{- end }}

{{- with .Values.tolerations }}
  {{- if not (kindIs "slice" .) }}
    {{- fail "ERROR: tolerations block must be a list!" }}
  {{- end }}
tolerations: {{ toYaml . | nindent 2 }}
{{- end }}

{{- with .Values.affinity }}
  {{- if not (kindIs "map" .) }}
    {{- fail "ERROR: affinity block must be a map!" }}
  {{- end }}
affinity: {{ toYaml . | nindent 2 }}
{{- end }}

{{- with .Values.topologySpreadConstraints }}
topologySpreadConstraints: {{- include "cf-common.v0.0.24.tplrender" (dict "Values" . "context" $) | nindent 2 }}
{{- end }}

{{- with .Values.controller.restartPolicy }}
restartPolicy: {{ . }}
{{- end }}

{{- end }}
