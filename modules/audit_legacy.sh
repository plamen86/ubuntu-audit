# audit_legacy
#
# Refer to Sections 2.1.1-10
#.

audit_legacy_inet() {
  verbose_message "Inet Services"
  for service_name in time echo discard daytime chargen fs dtspc \
    exec comsat talk finger uucp name xaudio netstat ufsd rexd \
    systat sun-dr uuidgen krb5_prop 100068 100146 100147 100150 \
    100221 100232 100235 kerbd rstatd rusersd sprayd walld \
    printer shell login telnet ftp tftp 100083 100229 100230 \
    100242 100234 100134 100155 rquotad 100424 100422; do
    check_inetd_service $service_name disabled
  done
}

audit_legacy_init() {
  verbose_message "Init Services"
  for service_name in llc2 pcmcia ppd slpd boot.server autoinstall \
    power bdconfig cachefs.daemon cacheos.finish asppp uucp flashprom \
    PRESERVE ncalogd ncad ab2mgr dmi mipagent nfs.client autofs rpc \
    directory ldap.client lp spc volmgt dtlogin ncakmod samba dhcp \
    nfs.server kdc.master kdc apache snmpdx; do
    check_initd_service $service_name disabled
  done
}

audit_legacy() {
  if [ "$os_name" = "SunOS" ] || [ "$os_name" = "Linux" ] || [ "$os_name" = "FreeBSD" ] || [ "$os_name" = "AIX" ]; then
    verbose_message "Legacy Inet/Init Services"
    if [ "$os_name" = "AIX" ]; then
      check_rctcp timed off
      check_subserver telnet tcp6 off
      check_subserver exec tcp6 off
      check_subserver daytime udp off
      check_subserver shell tcp6 off
      check_subserver cmsd sunrpc_tcp off
      check_subserver ttdbserver sunrpc_tcp off
      check_subserver uucp tcp off
      check_subserver time udp off
      check_subserver login tcp off
      check_subserver talk udp off
      check_subserver ntalk udp off
      check_subserver ftp tcp6 off
      check_subserver chargen tcp off
      check_subserver discard tcp off
      check_subserver dtspc tcp off
      check_subserver echo tcp off
      check_subserver echo udp off
      check_subserver pcnfsd udp off
      check_subserver rstatd udp off
      check_subserver rusersd udp off
      check_subserver rwalld udp off
      check_subserver sprayd udp off
      check_subserver klogin tcp off
      check_subserver rquotad udp off
      check_subserver tftp udp off
      check_subserver imap2 tcp off
      check_subserver pop3 tcp off
      check_subserver finger tcp off
      check_subserver instsrv tcp off
    else
      if [ "$os_name" = "SunOS" ]; then
        if [ "$os_version" != "11" ]; then
          audit_legacy_inet
          audit_legacy_init
        fi
      else
        audit_legacy_inet
        audit_legacy_init
      fi
    fi
  fi
}
