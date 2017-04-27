glt2017:
  '*':
    - match: compound
    - chrony.client
    - repoconf.salt
    - hosts

  'salt*':
    - match: compound
    - salt.master
    - serverpackages.install
    - firewalld.disable
    - pcs.clustermap
    - mysql.clustermap

  'db*':
    - match: compound
    - repoconf.percona
    - salt.minion
    - serverpackages.db
    - firewalld.disable
    - pcs.clustermap
    - pcs
    - mysql