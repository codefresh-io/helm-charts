{{/*
Return the target Kubernetes version
*/}}
{{- define "cf-common-0.34.0.kubeVersion" -}}
{{- default .Capabilities.KubeVersion.Version .Values.kubeVersionOverride -}}
{{- end -}}

{{/*
Return the appropriate apiVersion for HPA
*/}}
{{- define "cf-common-0.34.0.apiVersion.autoscaling" -}}
{{- if .Values.apiVersionOverrides -}}
  {{- if .Values.apiVersionOverrides.autoscaling -}}
    {{- print .Values.apiVersionOverrides.autoscaling -}}
  {{- else -}}
    {{- print "autoscaling/v2" -}}
  {{- end -}}
{{- else if semverCompare "<1.23-0" (include "cf-common-0.34.0.kubeVersion" . ) -}}
  {{- print "autoscaling/v2beta2" -}}
{{- else -}}
  {{- print "autoscaling/v2" -}}
{{- end -}}
{{- end -}}

{{/*
Return the appropriate apiVersion for External Secrets
(created for the migration from external-secrets.io/v1beta1 to v1)
*/}}
{{- define "cf-common-0.34.0.apiVersion.externalSecrets" -}}
{{- if .Values.apiVersionOverrides -}}
  {{- if .Values.apiVersionOverrides.externalSecrets -}}
    {{- print .Values.apiVersionOverrides.externalSecrets -}}
  {{- else -}}
    {{- print "external-secrets.io/v1" -}}
  {{- end -}}
{{- else -}}
  {{- print "external-secrets.io/v1" -}}
{{- end -}}
{{- end -}}
