logstash-pkg:
  pkg.installed:
    - sources:
      - logstash-forwarder: salt://logstash/files/logstash-forwarder-0.3.1-1.x86_64.rpm

/etc/pki/tls/certs/logstash-forwarder.crt:
  file.managed:
    - source:
      - salt://logstash/files/logstash-forwarder.crt
    - mode: 644

/etc/logstash-forwarder/logstash-forwarder.conf:
  file.managed:
    - source:
      - salt://logstash/files/logstash-forwarder.conf-php
    - mode: 644
    - makedirs: True

/etc/init.d/logstash-forwarder:
  file.managed:
    - source:
      - salt://logstash/files/logstash-forwarder-init
    - mode: 755

/etc/sysconfig/logstash-forwarder:
  file.managed:
    - source:
      - salt://logstash/files/logstash-forwarder-sysconfig
    - mode: 644

logstash-forwarder:
  service:
    - running
    - enable: True
    - watch:
      - file: /etc/logstash-forwarder/logstash-forwarder.conf
