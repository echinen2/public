/etc/php.ini:
  file.managed:
    - source:
      - salt://php-fpm/files/php.ini
    - mode: 644

/etc/sysconfig/php-fpm:
  file.managed:
    - source:
      - salt://php-fpm/files/php-fpm-sysconfig
    - mode: 644

/etc/php.d:
  file.recurse:
    - source: salt://php-fpm/files/php.d
    - include_empty: True
    - clean: True
    - file_mode: 644
    - dir_mode: 644

/etc/php-fpm.conf:
  file.managed:
    - source:
      - salt://php-fpm/files/php-fpm.conf
    - mode: 644

/etc/php-fpm.d:
  file.recurse:
    - source: salt://php-fpm/files/php-fpm.d
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


# Servico do php-fpm
# restarta apenas se houver alteracao nos arquivos
php-fpm:
  service:
    - running
    - enable: True
    - watch:
      - file: /etc/php.ini
      - file: /etc/php-fpm.conf
      - file: /etc/php.d
      - file: /etc/php-fpm.d
      - file: /etc/sysconfig/php-fpm
