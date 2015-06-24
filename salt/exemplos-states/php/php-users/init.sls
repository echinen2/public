php:
  group.present:
    - gid: 1001
    - system: True
  user.present:
    - shell: /bin/bash
    - home: /tmp
    - uid: 1001
    - gid: 1001
