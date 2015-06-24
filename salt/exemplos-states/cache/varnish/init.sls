# Arqs de conf do varnish
/etc/varnish/default.vcl:
  file.managed:
    - source:
      - salt://varnish/files/default.vcl
    - mode: 644

/etc/varnish/secret:
  file.managed:
    - source:
      - salt://varnish/files/secret
    - mode: 600

/etc/sysconfig/varnish:
  file.managed:
    - source:
      - salt://varnish/files/varnish-sysconfig
    - mode: 644

/etc/init.d/varnishncsa:
  file.managed:
    - source:
      - salt://varnish/files/varnishncsa-init.d
    - mode: 755

# Diretorio log do varnish
/mnt/md0/log/varnish:
  file.directory:
    - user: varnish
    - group: varnish
    - mode: 755
    - makedirs: True

# Servico Varnish
# restarta apenas se houver alteracao nos arquivos
varnish:
  service:
    - running
    - enable: True
    - watch:
      - file: /etc/varnish/default.vcl
      - file: /etc/varnish/secret
      - file: /etc/sysconfig/varnish

varnishncsa:
  service:
    - running
    - enable: True
    - watch:
      - file: /etc/init.d/varnishncsa
      - file: /etc/varnish/default.vcl
      - file: /etc/varnish/secret
      - file: /etc/sysconfig/varnish
