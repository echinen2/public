/etc/sysctl.d/99-salt.conf:
  file.symlink:
    - target: ../sysctl.conf
    - mode: 644

fs.file-max: 
  sysctl.present:
    - value: 2097152
kernel.core_uses_pid:
  sysctl.present:
    - value: 1
kernel.msgmax:
  sysctl.present:
    - value: 65536
kernel.msgmnb:
  sysctl.present:
    - value: 65536
kernel.shmall:
  sysctl.present:
    - value: 4294967296
kernel.shmmax:
  sysctl.present:
    - value: 68719476736
kernel.sysrq:
  sysctl.present:
    - value: 0
net.core.rmem_default:
  sysctl.present:
    - value: 16384
net.core.rmem_max:
  sysctl.present:
    - value: 262144
net.core.somaxconn:
  sysctl.present:
    - value: 10240
net.core.wmem_default:
  sysctl.present:
    - value: 16384
net.core.wmem_max:
  sysctl.present:
    - value: 262144
net.ipv4.conf.default.accept_source_route:
  sysctl.present:
    - value: 0
net.ipv4.conf.default.rp_filter:
  sysctl.present:
    - value: 0
net.ipv4.ip_forward:
  sysctl.present:
    - value: 0
net.ipv4.route.flush:
  sysctl.present:
    - value: 1
net.ipv4.tcp_max_syn_backlog:
  sysctl.present:
    - value: 10240
net.ipv4.tcp_max_tw_buckets:
  sysctl.present:
    - value: 262144
net.ipv4.tcp_rmem:
  sysctl.present:
    - value: 4096 16384 262144
net.ipv4.tcp_syncookies:
  sysctl.present:
    - value: 0
net.ipv4.tcp_wmem:
  sysctl.present:
    - value: 4096 16384 262144
vm.min_free_kbytes:
  sysctl.present:
    - value: 65536
vm.swappiness:
  sysctl.present:
    - value: 5
