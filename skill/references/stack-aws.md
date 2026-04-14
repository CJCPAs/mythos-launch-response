# AWS Hardening Reference

## Critical Checks

```bash
# 1. Root MFA
aws iam get-account-summary | grep AccountMFAEnabled  # Must be 1

# 2. Root access keys (should be 0)
aws iam get-account-summary | grep AccountAccessKeysPresent  # Must be 0

# 3. Users without MFA
aws iam generate-credential-report && aws iam get-credential-report --output text --query Content | base64 -d | awk -F, '$4 == "true" && $8 == "false" {print $1}'

# 4. Public S3 buckets
for b in $(aws s3api list-buckets --query 'Buckets[].Name' --output text); do aws s3api get-public-access-block --bucket $b 2>/dev/null || echo "NO BLOCK: $b"; done

# 5. Open security groups (0.0.0.0/0)
aws ec2 describe-security-groups --query 'SecurityGroups[?IpPermissions[?IpRanges[?CidrIp==`0.0.0.0/0`]]].[GroupId,GroupName]' --output table

# 6. GuardDuty
aws guardduty list-detectors  # Should not be empty
```

## Hardening Actions

1. Enable MFA on root, never use root for daily ops
2. Delete root access keys
3. Enable MFA on all IAM users
4. Block public S3 access at account level
5. Enable server-side encryption on all buckets
6. Close 0.0.0.0/0 rules on SSH (22), RDP (3389), database ports
7. Enable GuardDuty in all regions
8. Enable CloudTrail in all regions with log validation
9. Enable Security Hub with CIS Benchmark
10. Enforce IMDSv2 on all EC2 instances
11. Verify RDS instances are not publicly accessible

## Mythos Context
AWS is Glasswing partner. Expect accelerated patches for AWS services. IAM, S3, and Security Group misconfigurations are user responsibility.
