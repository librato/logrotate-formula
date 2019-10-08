{% from "logrotate/map.jinja" import logrotate with context %}

{%- if 'cron_run_hourly' in logrotate and logrotate.cron_run_hourly %}
logrotate_cron_run_hourly:
  file.rename:
    name: /etc/cron.daily/logrotate
    source: /etc/cron.hourly/logrotate
    force: True
{%- end if %}

logrotate:
  pkg.installed:
    - name: {{ logrotate.pkg|json }}
  service.running:
    - name: {{ logrotate.service }}
    - enable: True
    - reload: True

logrotate_directory:
  file.directory:
    - name: {{ logrotate.include_dir }}
    - user: {{ salt['pillar.get']('logrotate:config:user', logrotate.user) }}
    - group: {{ salt['pillar.get']('logrotate:config:group', logrotate.group) }}
    - mode: 755
    - makedirs: True
    - require:
      - pkg: logrotate
