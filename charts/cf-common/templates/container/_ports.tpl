{{/*
Renders ports map in container. Ports are obtained from .Values.service so root $ context should be passed.
Usage:
  ports: {{- include "cf-common.ports" $ | trim | nindent 2 }}
*/}}

{{- define "cf-common.ports" -}}

{{- $ports := list -}}
{{- range $serviceName, $serviceItem := .Values.service }}
  {{- range $portName, $portItem := .ports }}
  {{- $_ := set $portItem "name" $portName -}}
  {{- $ports = append $ports $portItem -}}
  {{- end }}
{{- end }}

{{- if $ports -}}

{{- range $i, $port := $ports }}
- name: {{ $port.name }}
  containerPort: {{ $port.targetPort | default $port.port }}
  {{- if $port.protocol }}
    {{- if or ( eq $port.protocol "HTTP" ) ( eq $port.protocol "HTTPS") ( eq $port.protocol "TCP" ) }}
  protocol: TCP
    {{- else }}
  protocol: {{ $port.protocol }}
    {{- end }}
  {{- else }}
  protocol: TCP
  {{- end }}
{{- end }}

{{- end -}}

{{- end -}}
