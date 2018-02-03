# audit_aws_redshift
#
# Refer to https://www.cloudconformity.com/conformity-rules/Redshift/cluster-allow-version-upgrade.html
# Refer to https://www.cloudconformity.com/conformity-rules/Redshift/redshift-cluster-audit-logging-enabled.html
# Refer to https://www.cloudconformity.com/conformity-rules/Redshift/redshift-cluster-encrypted.html
# Refer to https://www.cloudconformity.com/conformity-rules/Redshift/redshift-cluster-encrypted-with-kms-customer-master-keys.html
# Refer to https://www.cloudconformity.com/conformity-rules/Redshift/redshift-cluster-in-vpc.html
# Refer to https://www.cloudconformity.com/conformity-rules/Redshift/redshift-parameter-groups-require-ssl.html
# Refer to https://www.cloudconformity.com/conformity-rules/Redshift/redshift-cluster-publicly-accessible.html
#.

audit_aws_redshift () {
  verbose_message "Redshift"
  dbs=`aws redshift describe-clusters --region $aws_region --query 'Clusters[].ClusterIdentifier' --output text`
  for db in $dbs; do
    # Check if version upgrades are enabled
    check=`aws redshift describe-clusters --region $aws_region --cluster-identifier $db --query 'Clusters[].AllowVersionUpgrade' |grep true`
    if [ "$check" ]; then
      increment_secure "Redshift instance $db has version upgrades enabled"
    else
      increment_insecure "Redshift instance $db does not have version upgrades enabled"
      verbose_message "" fix
      verbose_message "aws redshift modify-cluster --region $aws_region --cluster-identifier $db --allow-version-upgrade" fix
      verbose_message "" fix
    fi
    # Check if audit logging is enabled
    check=`aws redshift describe-logging-status --region $aws_region --cluster-identifier $db |grep true`
    if [ "$check" ]; then
      increment_secure "Redshift instance $db has logging enabled"
    else
      increment_insecure "Redshift instance $db does not have logging enabled"
      verbose_message "" fix
      verbose_message "aws redshift enable-logging --region $aws_region --cluster-identifier $db --bucket-name <aws-redshift-audit-logs>" fix
      verbose_message "" fix
    fi
    # Check if encryption is enabled
    check=`aws redshift describe-logging-status --region $aws_region --cluster-identifier $db --query 'Clusters[].Encrypted' |grep true`
    if [ "$check" ]; then
      increment_secure "Redshift instance $db has encryption enabled"
    else
      increment_insecure "Redshift instance $db does not have encryption enabled"
    fi
    # Check if KMS keys are being used
    check=`aws redshift describe-logging-status --region $aws_region --cluster-identifier $db --query 'Clusters[].[Encrypted,KmsKeyId]' |grep true`
    if [ "$check" ]; then
      increment_secure "Redshift instance $db is using KMS keys"
    else
      increment_insecure "Redshift instance $db is not using KMS keys"
    fi
    # Check if EC2-VPC platform is being used rather than EC2-Classic
    check=`aws redshift describe-logging-status --region $aws_region --cluster-identifier $db --query 'Clusters[].VpcId' --output text`
    if [ "$check" ]; then
      increment_secure "Redshift instance $db is using the EC2-VPC platform"
    else
      increment_insecure "Redshift instance $db may be using the EC2-Classic platform"
    fi
    # Check that parameter groups require SSL
    groups=`aws redshift describe-logging-status --region $aws_region --cluster-identifier $db --query 'Clusters[].ClusterParameterGroups[].ParameterGroupName[]' --output text`
    for group in $groups; do
      check=`aws redshift describe-cluster-parameters --region $aws_region --parameter-group-name $group --query 'Parameters[].Description' |grep -i ssl`
      if [ "$check" ]; then
        increment_secure "Redshift instance $db parameter group $group is using SSL"
      else
        increment_insecure "Redshift instance $db parameter group $group is not using SSL"
      fi
    done
    # Check if Redshift is publicly available
    check=`aws redshift describe-clusters --region $aws_region --cluster-identifier $db --query 'Clusters[].PubliclyAccessible' |grep true`
    if [ ! "$check" ]; then
      increment_secure "Redshift instance $db is not publicly available"
    else
      increment_insecure "Redshift instance $db is publicly available"
    fi
  done
}
