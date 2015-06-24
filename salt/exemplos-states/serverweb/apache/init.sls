# Arqs de conf do apache
/etc/httpd/conf:
  file.recurse:
    - source: salt://apache/files/conf
    - include_empty: True
    - clean: True
    - file_mode: 644
    - dir_mode: 755

# Arqs SSL do apache
/etc/httpd/ssl:
  file.recurse:
    - source: salt://apache/files/ssl
    - include_empty: True
    - clean: True
    - file_mode: 644
    - dir_mode: 755

# Arqs SSL do apache
/etc/httpd/vhosts:
  file.recurse:
    - source: salt://apache/files/vhosts
    - include_empty: True
    - clean: True
    - file_mode: 644
    - dir_mode: 755

# Diretorio log do apache
/mnt/md0/log/http:
  file.directory:
    - user: apache
    - group: apache
    - mode: 755
    - makedirs: True

# Servico nginx
# restarta apenas se houver alteracao nos arquivos
httpd:
  service:
    - running
    - enable: True
    - watch:
      - file: /etc/httpd/conf
