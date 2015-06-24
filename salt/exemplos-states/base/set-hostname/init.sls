/scripts/tools/set-hostname.sh:
  file.managed:
    - source:
      - salt://set-hostname/set-hostname.sh
    - mode: 755

# Executa script 
/scripts/tools/set-hostname.sh 1:
  cmd.run:
    - cwd: /
