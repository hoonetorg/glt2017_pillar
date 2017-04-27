salt:
  master:
    worker_threads: 16
    hash_type: sha256
    pillar_roots:
      glt2017:
        - /srv/pillar/glt2017
    fileserver_backend:
      - roots
    file_roots:
      glt2017:
        - /srv/salt/glt2017
    file_recv: True
salt_formulas:
  git_opts:
    default:
      baseurl: https://github.com/hoonetorg
      basedir: /srv/formulas/base
      update: True
      options:
        rev: glt2017
  basedir_opts:
    makedirs: True
    user: root
    group: root
    mode: 755
  list:
    glt2017:
      - firewalld-formula
      - salt-chrony-formula
      - salt-formula
      - salt-hosts-formula
      - salt-modules
      - salt-pcs-formula
      - salt-repoconf-formula
      - salt-serverpackages-formula
      - saltstack-mysql-formula
      - sysctl-formula
