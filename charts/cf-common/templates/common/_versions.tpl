{{/*
Return the target Kubernetes version
*/}}
{{- define "cf-common-0.10.1.kubeVersion" -}}
{{- default .Capabilities.KubeVersion.Version .Values.kubeVersionOverride -}}
{{- end -}}

{{/*
Return the appropriate apiVersion for HPA
*/}}
{{- define "cf-common-0.10.1.apiVersion.autoscaling" -}}
{{- if .Values.apiVersionOverrides.autoscaling -}}
{{- print .Values.apiVersionOverrides.autoscaling -}}
{{- else if semverCompare "<1.26-0" (include "cf-common-0.10.1.kubeVersion") -}}
{{- print "autoscaling/v2beta2" -}}
{{- else -}}
{{- print "autoscaling/v2" -}}
{{- end -}}
{{- end -}}
