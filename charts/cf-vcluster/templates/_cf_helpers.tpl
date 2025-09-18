{{- define "cf-vcluster.kubeconfighost" -}}
  {{ if .Values.global.ingress.public.enabled -}}
    {{- tpl (printf "https://%s.%s" .Values.global.ingress.public.host.name .Values.global.ingress.public.host.domain ) . -}}
  {{- else if .Values.global.ingress.internal.enabled }}
    {{- tpl (printf "https://%s.%s" .Values.global.ingress.internal.host.name .Values.global.ingress.internal.host.domain) . -}}
  {{- else -}}
    {{- printf "https://%s.%s.svc.cluster.local" .Release.Name .Release.Namespace -}}
  {{- end -}}
{{- end -}}
