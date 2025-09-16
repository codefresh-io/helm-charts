# cf-vcluster

![Version: 0.28.0-0](https://img.shields.io/badge/Version-0.28.0--0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 0.28.0](https://img.shields.io/badge/AppVersion-0.28.0-informational?style=flat-square)

Umbrella chart over vCluster adjusted for Codefresh use cases - mainly in Crossplane compositions

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| codefresh |  | <https://codefresh-io.github.io/> |

## Requirements

| Repository | Name | Version |
|------------|------|---------|
|  | vcluster | 0.28.0 |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| global.ingress.internal.annotations."nginx.ingress.kubernetes.io/backend-protocol" | string | `"HTTPS"` |  |
| global.ingress.internal.annotations."nginx.ingress.kubernetes.io/ssl-passthrough" | string | `"true"` |  |
| global.ingress.internal.annotations."nginx.ingress.kubernetes.io/ssl-redirect" | string | `"true"` |  |
| global.ingress.internal.backendServiceOverride | object | `{}` | Possibility to override backend service name for ingress. If not set default vcluster backend service will be used |
| global.ingress.internal.enabled | bool | `false` |  |
| global.ingress.internal.host.domain | string | `"corp.local"` |  |
| global.ingress.internal.host.name | string | `"{{ .Release.Name }}"` |  |
| global.ingress.internal.ingressClassName | string | `"nginx-internal"` |  |
| global.ingress.public.annotations."nginx.ingress.kubernetes.io/backend-protocol" | string | `"HTTPS"` |  |
| global.ingress.public.annotations."nginx.ingress.kubernetes.io/ssl-passthrough" | string | `"true"` |  |
| global.ingress.public.annotations."nginx.ingress.kubernetes.io/ssl-redirect" | string | `"true"` |  |
| global.ingress.public.backendServiceOverride | object | `{}` | Possibility to override backend service name for ingress. If not set default vcluster backend service will be used |
| global.ingress.public.enabled | bool | `false` |  |
| global.ingress.public.host.domain | string | `"example.com"` |  |
| global.ingress.public.host.name | string | `"{{ .Release.Name }}"` |  |
| global.ingress.public.ingressClassName | string | `"nginx-public"` |  |
| vcluster.controlPlane.distro.k8s.apiServer.extraArgs[0] | string | `"--oidc-issuer-url=https://dexidp.shared-services.cf-infra.com"` |  |
| vcluster.controlPlane.distro.k8s.apiServer.extraArgs[1] | string | `"--oidc-client-id=vcluster-login"` |  |
| vcluster.controlPlane.distro.k8s.apiServer.extraArgs[2] | string | `"--oidc-username-claim=email"` |  |
| vcluster.controlPlane.distro.k8s.apiServer.extraArgs[3] | string | `"--oidc-groups-claim=groups"` |  |
| vcluster.controlPlane.distro.k8s.enabled | bool | `true` |  |
| vcluster.controlPlane.proxy.extraSANs[0] | string | `"{{ tpl (printf \"%s.%s.%s\" .Release.Name .Release.Namespace \".cluster.svc.local\") . }}"` |  |
| vcluster.controlPlane.proxy.extraSANs[1] | string | `"{{ tpl (printf \"%s.%s\" .Values.global.ingress.internal.host.name .Values.global.ingress.internal.host.domain) . }}"` |  |
| vcluster.controlPlane.proxy.extraSANs[2] | string | `"{{ tpl (printf \"%s.%s\" .Values.global.ingress.public.host.name .Values.global.ingress.public.host.domain) . }}"` |  |
| vcluster.experimental.deploy.vcluster.manifests | string | `"---\nkind: ClusterRoleBinding\napiVersion: rbac.authorization.k8s.io/v1\nmetadata:\n  name: oidc-cluster-admin\nroleRef:\n  apiGroup: rbac.authorization.k8s.io\n  kind: ClusterRole\n  name: cluster-admin\nsubjects:\n- kind: Group\n  name: rnd@codefresh.io\n---\nkind: ClusterRoleBinding\napiVersion: rbac.authorization.k8s.io/v1\nmetadata:\n  name: oidc-cluster-admin-octopus\nroleRef:\n  apiGroup: rbac.authorization.k8s.io\n  kind: ClusterRole\n  name: cluster-admin\nsubjects:\n- kind: Group\n  name: 787d1a9a-e488-4a77-bb6c-f4b2fdfd8cea # Codefresh R&D Team\n- kind: Group\n  name: 607a9f67-422c-4ca2-b8c4-d0be213b9650 # Codefresh SA Team\n- kind: Group\n  name: f8de82e2-cdb6-480a-8f37-9f958ea5fef5 # Codefresh Support Team\n- kind: Group\n  name: 16b3fb37-58f2-4786-8ca8-6f58d0410687 # Codefresh OSS Team\n- kind: Group\n  name: dc35779f-57d5-4dff-90c0-34c6e93fe7e7 # Codefresh OSS Team\n---\napiVersion: v1\nkind: ServiceAccount\nmetadata:\n  name: codefresh-pipelines-integration-cluster-admin\n  namespace: kube-system\n---\napiVersion: v1\nkind: Secret\nmetadata:\n  name: codefresh-pipelines-integration-cluster-admin-token\n  namespace: kube-system\n  annotations:\n    kubernetes.io/service-account.name: codefresh-pipelines-integration-cluster-admin\ntype: kubernetes.io/service-account-token\n---\nkind: ClusterRoleBinding\napiVersion: rbac.authorization.k8s.io/v1\nmetadata:\n  name: codefresh-pipelines-integration-cluster-admin\nroleRef:\n  apiGroup: rbac.authorization.k8s.io\n  kind: ClusterRole\n  name: cluster-admin\nsubjects:\n- kind: ServiceAccount\n  name: codefresh-pipelines-integration-cluster-admin\n  namespace: kube-system"` |  |
| vcluster.rbac.clusterRole.enabled | bool | `true` |  |
| vcluster.sync.fromHost.ingressClasses.enabled | bool | `true` |  |
| vcluster.sync.fromHost.nodes.enabled | bool | `true` |  |
| vcluster.sync.toHost.ingresses.enabled | bool | `true` |  |
| vcluster.sync.toHost.persistentVolumeClaims.enabled | bool | `true` |  |
| vcluster.sync.toHost.persistentVolumes.enabled | bool | `true` |  |
| vcluster.sync.toHost.serviceAccounts.enabled | bool | `true` |  |
| vcluster.sync.toHost.storageClasses.enabled | bool | `true` |  |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.9.1](https://github.com/norwoodj/helm-docs/releases/v1.9.1)
