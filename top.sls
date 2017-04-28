glt2017:
  '*':
    - match: compound
    - repoconf.salt
    - hosts

  'salt*':
    - match: compound
    - salt.master
    - serverpackages.salt
    - firewalld.disable
    - pcs.clustermap
    - mysql.clustermap

  'db*':
    - match: compound
    - repoconf.percona
    - serverpackages.db
    - firewalld.disable
    - pcs.clustermap
    - pcs
    - pcs.galeraip
    - mysql
