/scripts/logrotate-brlink/logrotate-brlink.sh:
  file.managed:
    - source:
      - salt://logrotate/files/logrotate-brlink/logrotate-brlink.sh
    - mode: 755
    - makedirs: True

/scripts/logrotate-brlink/upload_broken_to_s3.sh:
  file.managed:
    - source:
      - salt://logrotate/files/logrotate-brlink/upload_broken_to_s3.sh
    - mode: 755
    - makedirs: True

/etc/init.d/logrotate-brlink:
  file.managed:
    - source:
      - salt://logrotate/files/logrotate-brlink-initd
    - mode: 755

/etc/cron.d/logrotate-brlink:
  file.managed:
    - source:
      - salt://logrotate/files/logrotate-brlink-crond
    - mode: 644

# Manter service ativo (cria S em rc3.d)
logrotate-brlink:
  service.enabled

# Desativar servico nos runlevel 6 e 0 (cria K em rc6.d e rc0.d)
chkconfig off logrotate-brlink:
  cmd.run:
    - name: chkconfig --level 06 logrotate-brlink off
    - cwd: /

# Ativa servico para criar arquivo de lock
Start logrotate-brlink:
  cmd.run:
    - name: /etc/init.d/logrotate-brlink start
    - cwd: /

