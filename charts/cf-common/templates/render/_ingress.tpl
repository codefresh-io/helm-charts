{{/*
Renders Ingress templates
{{- include "cf-common-0.3.0.ingress" . -}}
*/}}
{{- define "cf-common-0.3.0.ingress" -}}

{{- range $ingressIndex, $ingressItem := .Values.ingress }}

{{- $ingressName := printf "%s-%s" (include "cf-common-0.3.0.names.fullname" $) $ingressIndex  -}}

{{- if $ingressItem.enabled }}
---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: {{ $ingressName }}
  labels: {{ include "cf-common-0.3.0.labels.standard" $ | nindent 4 }}
  {{- if $ingressItem.labels }}
  {{- include "cf-common-0.3.0.tplrender" (dict "Values" $ingressItem.labels "context" $) | nindent 4 }}
  {{- end }}
  {{- if $ingressItem.annotations }}
  annotations: {{- include "cf-common-0.3.0.tplrender" (dict "Values" $ingressItem.annotations "context" $) | nindent 4 }}
  {{- end }}
spec:
  {{- if $ingressItem.ingressClassName }}
  ingressClassName: {{ $ingressItem.ingressClassName }}
  {{- end }}
  {{- if $ingressItem.tls }}
  tls:
    {{- if not (kindIs "slice" $ingressItem.tls) }}
      {{- fail (printf "ERROR: ingress.%s.tls must be a list!" $ingressIndex) }}
    {{- end }}
    {{- range $ingressItem.tls }}
    - hosts:
        {{- range .hosts }}
        - {{ include "cf-common-0.3.0.tplrender" (dict "Values" . "context" $) | quote }}
        {{- end }}
      {{- if .secretName }}
      secretName: {{ include "cf-common-0.3.0.tplrender" (dict "Values" .secretName "context" $) | quote}}
      {{- end }}
    {{- end }}
  {{- end }}
  rules:
    {{- if not (kindIs "slice" $ingressItem.hosts) }}
      {{- fail (printf "ERROR: ingress.%s.hosts must be a list!" $ingressIndex) }}
    {{- end }}
  {{- range $ingressItem.hosts }}
    - host: {{ include "cf-common-0.3.0.tplrender" (dict "Values" .host "context" $) | quote }}
      http:
        paths:
          {{- if not (kindIs "slice" .paths) }}
            {{- fail (printf "ERROR: ingress.%s.hosts[].paths must be a list!" $ingressIndex ) }}
          {{- end }}
          {{- range .paths }}
          - path: {{ include "cf-common-0.3.0.tplrender" (dict "Values" .path "context" $) | quote }}
            pathType: {{ default "ImplementationSpecific" .pathType }}
            {{- $serviceName := required (printf "service.name is required for ingress %s!" $ingressIndex) .service.name }}
            {{- $servicePort := required (printf "service.port is required for ingress %s!" $ingressIndex) .service.port }}
            backend:
              service:
                name: {{ include "cf-common-0.3.0.tplrender" (dict "Values" $serviceName "context" $) }}
                port:
                  number: {{ include "cf-common-0.3.0.tplrender" (dict "Values" $servicePort "context" $) }}
          {{- end }}
  {{- end }}

{{- end }}

{{- end }}

{{- end -}}
