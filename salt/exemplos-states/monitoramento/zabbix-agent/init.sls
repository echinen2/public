zabbix-repo-pkg:
  pkg.installed:
    - sources:
      - zabbix-repo: salt://zabbix-agent/files/zabbix-release-2.2-1.el7.noarch.rpm

zabbix packages:
  pkg.installed:
    - pkgs:
      - zabbix-agent 
      
/etc/zabbix/zabbix_agentd.conf:
  file.managed:
    - source:
      - salt://zabbix-agent/files/zabbix_agentd.conf
    - mode: 644

#Ativa servico Zabbix Agent Proxy na inicializacao
systemctl enable zabbix-agent:
  cmd.run:
    - name: systemctl enable zabbix-agent
    - cwd: /

