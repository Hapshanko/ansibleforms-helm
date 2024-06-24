{{/* 
Define all mysql labels with iteration, for elegant use in templates
*/}}
{{ define "mysql.labels" }}
{{- range $key, $val := .Values.mysql.labels -}} 
{{ $key }}: {{ $val }} 
{{ end }}
{{- end -}}

{{/* 
Define all server (app) labels with iteration, for elegant use in templates
*/}}
{{ define "server.labels" }}
{{- range $key, $val := .Values.server.labels -}}
{{ $key }}: {{ $val }}
{{ end }}
{{- end -}}

{{ define  "server.image" }}
{{- printf "%s:%s" .Values.server.image.repository (.Values.server.image.tag | default .Chart.AppVersion) -}}
{{ end}}

{{ define  "mysql.image" }}
{{- printf "%s:%s" .Values.mysql.image.repository .Values.mysql.image.tag  -}}
{{ end}}

{{ define "baseURL" }}
{{- .Values.baseURL | default "/" -}}
{{ end }}

{{- define "enableHTTPS" -}}
{{- if or (eq .Values.expose.type "ingress") (not .Values.tls.enable) -}}
0
{{- else -}}
1
{{- end -}}
{{- end -}}
