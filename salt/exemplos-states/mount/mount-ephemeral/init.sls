/scripts/tools/format-ephemeral.sh:
  file.managed:
    - source:
      - salt://mount-ephemeral/format-ephemeral.sh
    - mode: 755

/scripts/tools/format-ephemeral.sh /dev/xvdb:
  cmd.run

/mnt/md0:
  mount.mounted:
    - device: /dev/xvdb
    - fstype: xfs
    - mkmnt: True
    - opts:
      - defaults,logbufs=8,logbsize=256k,noatime,nodiratime

