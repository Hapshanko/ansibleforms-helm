{{/* 
Define all mysql labels with iteration, for elegant use in templates
*/}}
{{- define "mysql.labels" }}
{{- range $key, $val := .Values.mysql.labels }}
{{ $key }}: {{ $val }}
{{- end }}
{{- end }}

{{/* 
Define all server (app) labels with iteration, for elegant use in templates
*/}}
{{- define "server.labels" }}
{{- range $key, $val := .Values.server.labels }}
{{ $key }}: {{ $val }}
{{- end }}
{{- end }}