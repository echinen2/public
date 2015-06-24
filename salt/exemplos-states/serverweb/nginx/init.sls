# Arqs de conf do nginx
/etc/nginx:
  file.recurse:
    - source: salt://nginx/files/
    - include_empty: True
    - clean: True
    - file_mode: 644
    - dir_mode: 755

# Site padrao nginx
/mnt/md0/default-site:
  file.recurse:
    - source: salt://nginx/default-site/
    - include_empty: True
    - clean: True
    - user: nginx
    - group: nginx
    - file_mode: 644
    - dir_mode: 755

# Diretorio log do nginx
/mnt/md0/log/nginx:
  file.directory:
    - user: nginx
    - group: nginx
    - mode: 755
    - makedirs: True

# Servico nginx
# restarta apenas se houver alteracao nos arquivos
nginx:
  service:
    - running
    - enable: True
    - watch:
      - file: /etc/nginx
