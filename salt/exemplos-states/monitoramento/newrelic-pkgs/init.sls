newrelic-repo-pkg:
  pkg.installed:
    - sources:
      - newrelic-repo: salt://newrelic-pkgs/files/newrelic-repo-5-3.noarch.rpm

newrelic packages:
  pkg.installed:
    - pkgs:
      - newrelic-php5
      - newrelic-sysmond

/etc/newrelic/nrsysmond.cfg:
  file.managed:
    - source:
      - salt://newrelic-pkgs/files/nrsysmond.cfg
    - mode: 644

newrelic-daemon:
  service:
    - running
    - enable: True

newrelic-sysmond:
  service:
    - running
    - enable: True
