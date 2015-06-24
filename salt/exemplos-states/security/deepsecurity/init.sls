/scripts/tools/deepsecurity.sh:
  file.managed:
    - source:
      - salt://deepsecurity/deepsecurity.sh
    - mode: 755

/scripts/tools/deepsecurity.sh 123:
  cmd.run
