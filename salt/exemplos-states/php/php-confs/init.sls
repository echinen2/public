/etc/php.ini:
  file.managed:
    - source:
      - salt://php-confs/files/php.ini
    - mode: 644


/etc/php.d:
  file.recurse:
    - source: salt://php-confs/files/php.d
    - include_empty: True
    - clean: True
    - file_mode: 644
    - dir_mode: 644

# Diretorio temp do PHP
/mnt/md0/php-tmp:
  file.directory:
    - user: php
    - group: php
    - mode: 755
    - makedirs: True

# Diretorio log do php
/mnt/md0/log/php:
  file.directory:
    - user: php
    - group: php
    - mode: 755
    - makedirs: True

