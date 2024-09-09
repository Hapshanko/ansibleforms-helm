{{ define "commonLabels" }}
    app.kubernetes.io/part-of: ansibleforms
    environment: {{ .Values.environment }}
{{- end -}}

{{/* 
Define all mysql labels with iteration, for elegant use in templates
*/}}
{{ define "mysql.labels" }}
    app.kubernetes.io/name: mysql
    app.kubernetes.io/component: database
    app.kubernetes.io/version: {{ .Values.mysql.image.tag }}
{{- end -}}

{{/* 
Define all server (app) labels with iteration, for elegant use in templates
*/}}
{{ define "server.labels" }}
    app.kubernetes.io/name: server
    app.kubernetes.io/component: backend
    app.kubernetes.io/version: {{ .Values.server.image.tag }}
{{- end -}}

{{ define  "server.image" }}
{{- printf "%s/%s:%s" .Values.server.image.registry .Values.server.image.repository (.Values.server.image.tag | default .Chart.AppVersion) -}}
{{ end}}

{{ define  "mysql.image" }}
{{- printf "%s:%s" .Values.mysql.image.registry .Values.mysql.image.repository .Values.mysql.image.tag  -}}
{{ end}}

{{ define "app.servicePort" }}
    {{- if not .Values.tls.enable -}}
    80
    {{- else -}}
    443
    {{- end -}}
{{- end -}}

{{- define "enableHTTPS" -}}
    {{- if or (eq ( lower .Values.expose.type "ingress") "ingress") (not .Values.tls.enable) -}}
    0
    {{- else -}}
    1
    {{- end -}}
{{- end -}}

{{- define "certificateSecretName" -}}
    {{- if eq (lower .Values.tks.certSource) "secret" -}}
    {{- print .Values.tls.secretName -}}
    {{- else -}}
    {{- print "server-certificate" -}}
    {{- end -}}
{{- end -}}

{{- define "databaseSecretName" -}}
    {{- if eq (lower .Values.mysql.credentials.source) "secret" }}
    {{- print .Values.mysql.credentials.secretName -}}
    {{- else -}}
    {{- print "database-credentials" -}}
    {{- end -}}
{{- end -}}
