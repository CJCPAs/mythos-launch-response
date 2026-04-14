# AWS Security Hardening Guide

**For organizations running infrastructure on AWS in the post-Mythos era.**

AWS is a Glasswing founding partner. They're scanning their code. But your IAM policies, security groups, S3 buckets, and configurations are your responsibility.

---

## 1. IAM (Identity and Access Management)

This is the most important section. IAM misconfigurations are the #1 cause of AWS breaches.

### Root Account

- [ ] **MFA enabled on root account** (hardware key preferred)
  ```bash
  aws iam get-account-summary | grep AccountMFAEnabled
  # Must return: "AccountMFAEnabled": 1
  ```
- [ ] **Root account has no access keys**
  ```bash
  aws iam get-account-summary | grep AccountAccessKeysPresent
  # Must return: "AccountAccessKeysPresent": 0
  ```
- [ ] Root account is NEVER used for daily operations
- [ ] Root account email is a shared/team mailbox, not a personal email

### IAM Users and Roles

- [ ] **Every human user has their own IAM user** (no shared accounts)
- [ ] **MFA enabled on all IAM users**
  ```bash
  # Find users without MFA
  aws iam generate-credential-report
  aws iam get-credential-report --output text --query Content | base64 -d | \
    awk -F, '$4 == "true" && $8 == "false" {print $1, "- NO MFA"}'
  ```
- [ ] **Least privilege enforced** — no user or role has `*:*` permissions
  ```bash
  # Find policies with full admin access
  aws iam list-policies --only-attached --query 'Policies[?PolicyName==`AdministratorAccess`]'
  
  # List who has admin access
  aws iam get-policy-version --policy-arn arn:aws:iam::aws:policy/AdministratorAccess \
    --version-id v1
  ```
- [ ] **Access keys rotated within 90 days**
  ```bash
  # Find old access keys
  aws iam generate-credential-report
  aws iam get-credential-report --output text --query Content | base64 -d | \
    awk -F, 'NR>1 && $9 == "true" {print $1, $10}'
  ```
- [ ] **Unused IAM users disabled**
- [ ] **Use IAM Roles** for EC2, Lambda, and services instead of access keys where possible

---

## 2. S3 Bucket Security

S3 misconfigurations have caused some of the largest data breaches in history.

```bash
# List all buckets
aws s3api list-buckets --query 'Buckets[].Name'

# Check each bucket for public access
for bucket in $(aws s3api list-buckets --query 'Buckets[].Name' --output text); do
  echo "=== $bucket ==="
  aws s3api get-public-access-block --bucket $bucket 2>/dev/null || echo "NO PUBLIC ACCESS BLOCK!"
  aws s3api get-bucket-policy-status --bucket $bucket 2>/dev/null || echo "No policy"
done
```

- [ ] **Block Public Access enabled** on ALL buckets (unless explicitly intended to be public)
  ```bash
  # Enable account-level public access block
  aws s3control put-public-access-block --account-id $(aws sts get-caller-identity --query Account --output text) \
    --public-access-block-configuration \
    BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true
  ```
- [ ] **Server-side encryption enabled** on all buckets
  ```bash
  # Check encryption status
  for bucket in $(aws s3api list-buckets --query 'Buckets[].Name' --output text); do
    echo -n "$bucket: "
    aws s3api get-bucket-encryption --bucket $bucket 2>/dev/null && echo "ENCRYPTED" || echo "NOT ENCRYPTED"
  done
  ```
- [ ] **Versioning enabled** on buckets with important data (ransomware protection)
- [ ] **Access logging enabled** on sensitive buckets
- [ ] **Bucket policies reviewed** — no unintended `Principal: "*"` statements
- [ ] **No sensitive data in bucket names** (bucket names are globally unique and guessable)

---

## 3. Network Security (VPC / Security Groups)

```bash
# Find security groups that allow unrestricted inbound access
aws ec2 describe-security-groups --query \
  'SecurityGroups[?IpPermissions[?IpRanges[?CidrIp==`0.0.0.0/0`]]].[GroupId,GroupName,Description]' \
  --output table
```

- [ ] **No security groups with 0.0.0.0/0 on SSH (22) or RDP (3389)**
- [ ] **No security groups with 0.0.0.0/0 on database ports** (3306, 5432, 6379, 27017)
- [ ] **Default security group** has all inbound/outbound rules removed
- [ ] **VPC Flow Logs enabled** for network traffic monitoring
  ```bash
  # Check for VPC flow logs
  aws ec2 describe-flow-logs --query 'FlowLogs[].{VPC:ResourceId,Status:FlowLogStatus}'
  ```
- [ ] **Unused security groups cleaned up** — every security group should have a clear purpose

---

## 4. Logging and Monitoring

### CloudTrail

- [ ] **CloudTrail enabled in ALL regions** (attackers use regions you don't monitor)
  ```bash
  aws cloudtrail describe-trails --query 'trailList[].{Name:Name,IsMultiRegion:IsMultiRegionTrail}'
  ```
- [ ] **Log file validation enabled** (prevents log tampering)
- [ ] **Logs stored in a separate account** (so a compromised account can't delete its own audit trail)
- [ ] **CloudTrail integrated with CloudWatch Logs** for alerting

### GuardDuty

- [ ] **GuardDuty enabled**
  ```bash
  aws guardduty list-detectors
  # If empty, enable it:
  aws guardduty create-detector --enable
  ```
- [ ] GuardDuty findings reviewed weekly (or integrated into alerting)
- [ ] GuardDuty enabled in all regions

### Security Hub

- [ ] **Security Hub enabled** — aggregates findings from GuardDuty, Inspector, and more
- [ ] **AWS Foundational Security Best Practices standard** enabled
- [ ] **CIS AWS Foundations Benchmark** enabled
- [ ] Findings reviewed and triaged weekly

---

## 5. Compute Security

### EC2

- [ ] All instances use **IMDSv2** (prevents SSRF-based credential theft)
  ```bash
  # Find instances using IMDSv1
  aws ec2 describe-instances --query \
    'Reservations[].Instances[?MetadataOptions.HttpTokens!=`required`].[InstanceId,Tags[?Key==`Name`].Value|[0]]' \
    --output table
  ```
- [ ] **No EC2 instances with public IPs** unless explicitly needed
- [ ] **Systems Manager (SSM)** used instead of SSH for server access where possible
- [ ] **EBS volumes encrypted**
- [ ] **AMIs don't contain secrets**

### Lambda

- [ ] Lambda functions use **least-privilege IAM roles** (not `*:*`)
- [ ] Environment variables with secrets use **KMS encryption**
- [ ] Lambda functions have appropriate **timeout and memory limits** (prevent DoS via runaway execution)
- [ ] Lambda **reserved concurrency** set to prevent account-wide exhaustion
- [ ] No secrets hardcoded in Lambda code (use Secrets Manager or Parameter Store)

### RDS

- [ ] **Not publicly accessible** (most common RDS misconfiguration)
  ```bash
  aws rds describe-db-instances --query \
    'DBInstances[?PubliclyAccessible==`true`].[DBInstanceIdentifier,Engine]' --output table
  ```
- [ ] **Encryption at rest enabled**
- [ ] **Automated backups enabled** with appropriate retention
- [ ] **IAM database authentication** used where possible
- [ ] **SSL/TLS required** for all connections
- [ ] **Minor version auto-upgrade enabled**

---

## 6. Secrets Management

- [ ] **AWS Secrets Manager** or **Parameter Store** used for all secrets (not environment variables or code)
- [ ] **Automatic rotation enabled** on Secrets Manager secrets
- [ ] **No secrets in CloudFormation/Terraform state files** (or state files are encrypted and access-controlled)
- [ ] **No secrets in Lambda environment variables** without KMS encryption
- [ ] **No secrets in EC2 user data** (visible in instance metadata)

---

## 7. Cost and Access Anomaly Detection

- [ ] **AWS Budgets** configured with alerts (unexpected cost = potential crypto mining or abuse)
- [ ] **Billing alerts** enabled
- [ ] **Trusted Advisor** reviewed (free tier includes security checks)
- [ ] **IAM Access Analyzer** enabled — finds resources shared with external accounts
  ```bash
  aws accessanalyzer list-analyzers
  ```

---

## 8. Mythos-Specific Concerns

AWS is a Glasswing founding partner. Expect:
- Accelerated security patches for AWS services through July 2026
- Possible new findings in Linux kernel (EC2 runs on Linux)
- Possible findings in Firecracker (Lambda/Fargate isolation)

But your config is yours:
- IAM policies, security groups, S3 permissions, and encryption settings are NOT scanned by Glasswing
- A perfectly patched AWS region is still compromised if your IAM user has `*:*` and no MFA

---

## Quick Wins (Do Today)

1. Enable MFA on root account — 5 minutes, prevents account takeover
2. Run the security group audit command — find 0.0.0.0/0 rules
3. Enable GuardDuty — one API call
4. Block public S3 access at account level — one API call
5. Generate IAM credential report — find users without MFA and old access keys
