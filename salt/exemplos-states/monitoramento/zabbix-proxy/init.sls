zabbix-repo-pkg:
  pkg.installed:
    - sources:
      - zabbix-repo: salt://zabbix-proxy/files/zabbix-release-2.2-1.el7.noarch.rpm

zabbix packages:
  pkg.installed:
    - pkgs:
      - zabbix-proxy 
      - zabbix-proxy-mysql 
      
/etc/zabbix/zabbix_agentd.conf:
  file.managed:
    - source:
      - salt://zabbix-proxy/files/zabbix_proxy.conf
    - mode: 644

#Ativa servico Zabbix  Proxy na inicializacao
systemctl enable zabbix-proxy:
  cmd.run:
    - name: systemctl enable zabbix-proxy
    - cwd: /
