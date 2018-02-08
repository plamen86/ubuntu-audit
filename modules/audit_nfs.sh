# audit_nfs
# Refer to Section 2.2.7
#.

audit_nfs () {
  if [ "$nfsd_disable" = "yes" ]; then
    verbose_message "Section 2.2.7: NFS Services"

    for service_name in nfs nfslock portmap rpc nfs-kerner-server rpcbind; do
      check_systemctl_service disable $service_name
      check_chkconfig_service $service_name 3 off
      check_chkconfig_service $service_name 5 off
    done
  fi
}
