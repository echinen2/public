/etc/localtime:
  file.managed:
    - source:
      - salt://localtime/localtime
    - mode: 440

