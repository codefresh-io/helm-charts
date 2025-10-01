{{- range $i, $val := (list "internal" "public") }}
{{- $ingress := index $.Values.global.ingress $val -}}
  {{- if and $ingress.enabled }}
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: {{ printf "%s-%s" $.Release.Name $val }}
  {{- if $ingress.annotations }}
  annotations:
    {{- $ingress.annotations | toYaml | nindent 4 }}
  {{- end }}
spec:
  ingressClassName: {{ $ingress.ingressClassName | quote }}
  rules:
  - host: {{ tpl (printf "%s.%s" $ingress.host.name $ingress.host.domain) $ }}
    http:
      paths:
      - path: /
        pathType: {{ $.Values.vcluster.controlPlane.ingress.pathType }}
        backend:
          {{- if $.Values.automaticScaleDown.enabled}}
          service:
            name: {{ $.Release.Name }}-keda-http-interceptor
            port:
              number: {{ $.Values.automaticScaleDown.interceptor.port }}
        {{- else }}
          service:
            name: {{ $.Release.Name }}
            port:
              name: https
        {{- end }}
---
  {{ end -}}
{{ end -}}
