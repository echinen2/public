/etc/sudoers:
  file.managed:
    - source:
      - salt://sudoers/sudoers
    - mode: 440

