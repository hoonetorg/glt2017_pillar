{% set data = "/var/lib/mysql" %}
{% set log = "/var/log/mysqld.log" %}
{% set pid = "/run/mysqld/mysql.pid" %}
{% set sock = data ~ "/mysql.sock" %}

mysql:
  lookup:
    #type: mariadb_galera
    type: pxc

    salt:
      config:
        states:
          user: root
          pass: glt2017
          host: localhost
          socket: {{sock}}

    pcs:
      galera_cib: cib_for_galera
      resource_name: galera
      wsrep_cluster_address: gcomm://db1,db2,db3
      master_max: 3
      ordered: true
      op_demote_timeout: 300s
      op_monitor_timeout: 300s
      op_promote_timeout: 300s
      op_start_timeout: 300s
      op_stop_timeout: 300s

      # why do i have this? #on_fail: block
      datadir: {{data}}
      log: {{log}}
      socket: {{sock}}
      pid: {{pid}}
      constraints:
        colocation-vip_galera-galera-master-INFINITY:
          constraint_options:
          - add
          - vip_galera
          - with
          - galera-master
          constraint_type: colocation
        order-galera-master-vip_galera-Mandatory:
          constraint_options:
          - promote
          - galera-master
          - then
          - start
          - vip_galera
          - kind=Mandatory
          constraint_type: order

    #mariadb_galera:
    pxc:
      clustercheck:
        user:
          name: clustercheckuser
          password: glt2017
          host: localhost
        #defaultsfile:
        #  path: /etc/default/clustercheck
        #  group: root

      #selinux_type: mariadb-server

      #client:
      #  pkgs:
      #    - Percona-Server-client-57

      server:
        sls_include: []

        #pkgs:
        #- mariadb-server-galera
        #- Percona-XtraDB-Cluster-57
        #- MySQL-python

        service:
          #name: mysql
          enable: false
          ensure: disabled

        rootpwd: glt2017

        config:
          manage:
          - my
          my:
            path: /etc/my.cnf
            mode: '0644'

            config:
              file_prepend: |
                # DO NOT CHANGE THIS FILE!
                # This config is generated by SALTSTACK
                # and all change will be overrided on next salt call

              sections:
                mysqld:
                - name: PXC57
                #  for PXC 5.7
                  innodb_locks_unsafe_for_binlog: 1
                #  explicit_defaults_for_timestamp: "1"
                #  server_id: {{grains['host'][-1]}}
                #  wsrep_on: 1

                - name: TUNING
                  innodb_buffer_pool_size: {{(grains['mem_total']*0.3)|round|int}}M
                  innodb_log_files_in_group: 2
                  innodb_log_file_size: 40M
                  innodb_open_files: 2000

                  max_connections: 2048

                  ## open files double or triple of table_open_cache
                  open_files_limit: 12000

                  ## table cache
                  table_open_cache: 4000
                  table_definition_cache: 3000

                  ## join
                  join_buffer_size: 262144

                  max_allowed_packet: 8388608

                - name: MISC
                  bind_address: 0.0.0.0
                  port: 3306

                  symbolic_links: 0

                  character_set_server: utf8
                  collation_server: utf8_general_ci

                  datadir: {{data}}

                  socket: {{sock}}

                  innodb_file_per_table: 1

                  query_cache_size: 0
                  query_cache_type: 0

                  ## expire logs
                  #expire_logs_days: 7

                  ## slow query log
                  #slow_query_log: ON
                  #long_query_time: 0.5

                  #debug: 0

                - name: GALERA MYSQL SETTINGS
                  default_storage_engine: innodb
                  binlog_format: ROW
                  log_bin: ''

                  innodb_flush_log_at_trx_commit: 0
                  innodb_flush_method: O_DIRECT
                  innodb_autoinc_lock_mode: 2

                  skip_name_resolve: 0

                  transaction_isolation: READ-COMMITTED

                - name: GALERA WSREP SETTINGS
                  wsrep_cluster_name: pxc_cluster
                  wsrep_cluster_address: gcomm://db1,db2,db3
                  wsrep_node_name: {{grains.id.split('.')[0]}}
                  wsrep_node_address: {{grains.fqdn_ip4}}

                  wsrep_auto_increment_control: 1
                  wsrep_causal_reads: 0
                  wsrep_certify_nonPK: 1
                  wsrep_convert_LOCK_to_trx: 0
                  wsrep_debug: 0
                  wsrep_drupal_282555_workaround: 0
                  wsrep_max_ws_rows: 131072
                  wsrep_max_ws_size: 1073741824
                  wsrep_notify_cmd: ''
                  #wsrep_provider: /usr/lib64/galera/libgalera_smm.so
                  wsrep_provider: /usr/lib64/galera3/libgalera_smm.so
                  wsrep_retry_autocommit: 1

                  wsrep_slave_threads: 8

                  wsrep_sst_method: rsync
                  #wsrep_sst_method: xtrabackup-v2
                  #wsrep_sst_auth: root:glt2017

                mysqld_safe:
                - name: MISC
                  log-error: {{log}}
                  pid_file: {{pid}}

                client:
                  - name: client
                    socket: {{sock}}

      dbmgmt:
        require: []

      databases:
        glt2017: {}

      grants:
      - database: glt2017.*
        host: '''localhost'''
        user: glt2017
      - database: glt2017.*
        host: '''%'''
        user: glt2017

      users:
      - name: glt2017
        host: '''localhost'''
        password: glt2017
        unix_socket: false
      - name: glt2017
        host: '''%'''
        password: glt2017
        unix_socket: false
