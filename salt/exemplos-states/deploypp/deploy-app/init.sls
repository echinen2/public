/mnt/md0/app:
  file.directory:
#    - user: apache
#    - group: apache
    - user: nginx
    - group: nginx
    - mode: 755
    - makedirs: True

/scripts/tools/deploy-app.sh:
  file.managed:
    - source:
      - salt://deploy-app/deploy-app.sh
    - mode: 755

/scripts/tools/deploy-app.sh once-at-boot:
  cmd.run
