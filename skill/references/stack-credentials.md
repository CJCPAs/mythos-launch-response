# Credential Security Reference

## Password Policy

- Minimum 16 characters
- Unique for every account
- Stored in password manager (Bitwarden recommended for SMBs, 1Password for teams needing admin features)
- Rotation: financial accounts every 6 months, admin/API keys every 90 days, others on compromise

## MFA Priority Order

1. Email (master key to all other accounts)
2. Password manager (keys to the kingdom)
3. Banking and financial
4. Cloud and hosting
5. Domain registrar
6. Everything else

Methods ranked: Hardware key > Authenticator app > Push > SMS (last resort)

## Banking Security

- Transaction alerts on ALL accounts
- Positive pay / ACH filters if bank offers
- Dual authorization for wires
- Dedicated banking device if practical
- Individual credit cards per employee with limits
- Review connected bank feeds in accounting software

## Payroll Protection

- MFA on payroll system
- Dual authorization for routing number changes
- Phone verification for direct deposit changes
- Separation of duties (entry vs approval)

## Recovery Planning

- Recovery codes generated, printed, stored in physical safe
- Password manager emergency access configured
- Succession plan for digital accounts documented

## Breach Response

1. Change password from DIFFERENT device
2. Check for forwarding rules / unauthorized changes
3. Sign out all sessions
4. Check financial accounts
5. Alert team
6. Document with timestamps
