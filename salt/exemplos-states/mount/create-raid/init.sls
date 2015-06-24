/scripts/tools/create-raid.sh:
  file.managed:
    - source:
      - salt://create-raid/create-raid.sh
    - mode: 755

Run create-raid.sh:
  cmd.run:
    - name: /scripts/tools/create-raid.sh
    - cwd: /

/mnt/md0:
  mount.mounted:
    - device: /dev/md0
    - fstype: xfs
    - mkmnt: True
    - opts:
      - defaults,sunit=128,swidth=512,logbufs=8,logbsize=256k,noatime,nodiratime

