{{- define "cf-common-0.15.0.external-secrets" }}
  {{- range $i, $secret := .Values.externalSecrets }}
apiVersion: external-secrets.io/v1beta1
kind: ExternalSecret
metadata:
  name: {{ $secret.name }}
spec:
  refreshInterval: 1m
    {{- if hasKey . "secretStoreRef" }}
  secretStoreRef:
    name: {{ .secretStoreRef.name }}
    kind: {{ .secretStoreRef.kind | default "ClusterSecretStore" }}
    {{- else }}
  secretStoreRef:
    name: asm
    kind: ClusterSecretStore
    {{- end }}
  target:
    name: {{ .name }}
    creationPolicy: Owner
  data:
    {{- range $i, $key := $secret.keys }}
  - secretKey: {{ $key.name }}
    remoteRef:
        {{- if hasKey $key "remoteSecretName"}}
      key: {{ $key.remoteSecretName }}
        {{- else }}
      key: {{ $secret.remoteSecretName }}
        {{- end }}
      property: {{ $key.remoteKey }}
      {{- with $key.decodingStrategy }}
      decodingStrategy: {{ . }}
      {{- end -}}
    {{- end }}
---
  {{- end }}
{{- end }}
