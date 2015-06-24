/scripts/tools/create-swap.sh:
  file.managed:
    - source:
      - salt://create-swap/create-swap.sh
    - mode: 755

# Executa script 
# $1 = swap file
# $2 = tamanho do swap file
/scripts/tools/create-swap.sh /mnt/md0/swap 1024:
  cmd.run:
    - cwd: /

/mnt/md0/swap:
  mount.swap
