pcs:
  lookup:
    pcspasswd: glt2017
    pcspasswd_hash: $6$RqCsA/Hs0fQ$KrjRNU2u9WRZ2ZSVTqWsMdv.NAqEnseaJXxe3UjGs9G1dT1o/dmP8ni44FdmcB/e8ROcGG20ekCXc3tLiP1UB1

    setup_extra_args:
    - --start
    - --enable

    node_present_extra_args:
    - --start
    - --enable

    cluster_settings_cib: cib_for_cluster_settings
    properties:
      stonith-enabled: 'false'
    defaults:
      resource-stickiness: INFINITY

    stonith_cib: cib_for_stonith
    resources_cib: cib_for_pcs_resources
