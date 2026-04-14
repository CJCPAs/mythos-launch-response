# WordPress Security Hardening Guide

**For organizations running WordPress sites in the post-Mythos era.**

WordPress powers roughly 40% of the web. It's also one of the most targeted platforms — plugins, themes, and core all present attack surface. AI-assisted attackers will automate the discovery of plugin vulnerabilities at unprecedented scale.

---

## 1. Core WordPress

### Update Everything

```bash
# WP-CLI: Update core, all plugins, and all themes
wp core update
wp plugin update --all
wp theme update --all

# Check current versions
wp core version
wp plugin list --fields=name,version,update_version,status
wp theme list --fields=name,version,update_version,status
```

- [ ] **Auto-updates enabled for core** — Settings → Updates → Enable automatic updates for all new versions
- [ ] **Auto-updates enabled for all plugins** — Plugins → Enable auto-updates for each
- [ ] **Auto-updates enabled for all themes** — Themes → Enable auto-updates
- [ ] **PHP version is current** (8.2+ minimum, 8.3 recommended)
- [ ] **MySQL/MariaDB version is current**

### Plugin Audit

Plugins are the #1 attack vector for WordPress sites.

- [ ] **Remove all inactive plugins** — inactive doesn't mean safe. The code is still on the server.
- [ ] **Remove all unused themes** — keep only your active theme and one default fallback
- [ ] **Audit each active plugin:**
  - When was it last updated? (>12 months = risk)
  - How many active installations? (<1,000 = higher risk)
  - Does it have a security track record? (check WPScan Vulnerability Database)
  - Does it need the permissions it has? (a contact form plugin shouldn't need file system access)
- [ ] **Never install plugins from** unofficial sources, nulled/pirated plugins, or random zip files
- [ ] **Check for known vulnerable plugins:**
  ```bash
  # WPScan (free API key available)
  wpscan --url https://yoursite.com --enumerate vp --api-token YOUR_TOKEN
  ```

---

## 2. Authentication and Access

### Admin Security

- [ ] **Change the default admin username** — if your admin is "admin", attackers already know half the credential
- [ ] **Use strong unique passwords** (16+ characters, password manager)
- [ ] **Enable two-factor authentication** — plugins: WP 2FA, Two Factor Authentication, or Wordfence
- [ ] **Limit login attempts** — plugins: Limit Login Attempts Reloaded, or handled by Wordfence
- [ ] **Hide the login page** (optional but reduces automated attacks):
  ```
  # Change wp-login.php URL via plugin (WPS Hide Login)
  # Or via server config — NOT security through obscurity alone, but reduces noise
  ```

### User Audit

- [ ] Review all user accounts: Users → All Users
- [ ] Remove any unknown or inactive accounts
- [ ] Verify each account has the minimum necessary role (don't make everyone an admin)
- [ ] Disable user registration if not needed: Settings → General → Uncheck "Anyone can register"

### XML-RPC

- [ ] **Disable XML-RPC** unless you specifically need it (Jetpack, WordPress mobile app)
  ```apache
  # .htaccess
  <Files xmlrpc.php>
    Order Allow,Deny
    Deny from all
  </Files>
  ```
  Or use a security plugin to disable it.

---

## 3. Server-Level Hardening

### File Permissions

```bash
# Set correct file permissions
find /var/www/html -type d -exec chmod 755 {} \;
find /var/www/html -type f -exec chmod 644 {} \;

# Protect wp-config.php
chmod 600 wp-config.php

# Protect .htaccess
chmod 644 .htaccess
```

### wp-config.php Security

```php
// Add to wp-config.php:

// Disable file editing from admin panel (prevents attackers from editing theme/plugin files)
define('DISALLOW_FILE_EDIT', true);

// Force SSL for admin
define('FORCE_SSL_ADMIN', true);

// Limit post revisions (reduces database bloat)
define('WP_POST_REVISIONS', 5);

// Unique security keys (regenerate at https://api.wordpress.org/secret-key/1.1/salt/)
// Replace the default keys in wp-config.php with fresh ones
```

### .htaccess Hardening

```apache
# Protect wp-includes
<IfModule mod_rewrite.c>
  RewriteEngine On
  RewriteBase /
  RewriteRule ^wp-admin/includes/ - [F,L]
  RewriteRule !^wp-includes/ - [S=3]
  RewriteRule ^wp-includes/[^/]+\.php$ - [F,L]
  RewriteRule ^wp-includes/js/tinymce/langs/.+\.php - [F,L]
  RewriteRule ^wp-includes/theme-compat/ - [F,L]
</IfModule>

# Prevent directory browsing
Options -Indexes

# Block access to sensitive files
<FilesMatch "^(wp-config\.php|readme\.html|license\.txt)$">
  Order Allow,Deny
  Deny from all
</FilesMatch>

# Security headers
<IfModule mod_headers.c>
  Header set X-Content-Type-Options "nosniff"
  Header set X-Frame-Options "SAMEORIGIN"
  Header set X-XSS-Protection "1; mode=block"
  Header set Referrer-Policy "strict-origin-when-cross-origin"
  Header set Strict-Transport-Security "max-age=31536000; includeSubDomains"
</IfModule>
```

---

## 4. Security Plugins

Pick ONE comprehensive security plugin (running multiple causes conflicts):

| Plugin | Free Tier | Notes |
|--------|-----------|-------|
| **Wordfence** | Yes | Firewall, malware scan, login security, real-time threat intelligence |
| **Sucuri Security** | Yes | Audit logging, file integrity monitoring, remote malware scanning |
| **iThemes Security** | Yes | 30+ security hardening steps, two-factor auth, brute force protection |
| **All-In-One WP Security** | Yes | Comprehensive free option with good UI |

Whichever you choose:
- [ ] Firewall enabled and configured
- [ ] Malware scanning scheduled (daily)
- [ ] File integrity monitoring enabled
- [ ] Login protection (limit attempts, CAPTCHA, 2FA)
- [ ] Email alerts configured for security events

---

## 5. Database Security

```sql
-- Change the default table prefix (if still wp_)
-- This must be done carefully - backup first!
-- Better to set a custom prefix during initial installation

-- Remove unused data
DELETE FROM wp_posts WHERE post_type = 'revision';
DELETE FROM wp_options WHERE option_name LIKE '%_transient_%';

-- Check for unknown admin users
SELECT * FROM wp_users 
JOIN wp_usermeta ON wp_users.ID = wp_usermeta.user_id 
WHERE wp_usermeta.meta_key = 'wp_capabilities' 
AND wp_usermeta.meta_value LIKE '%administrator%';
```

- [ ] Database backups automated (daily minimum)
- [ ] Database credentials are strong and unique
- [ ] Database is not accessible from the internet (localhost or private network only)
- [ ] Table prefix is not the default `wp_` (for new installations)

---

## 6. Backup Strategy

- [ ] **Daily automated backups** — plugins: UpdraftPlus, BlogVault, BackWPup
- [ ] Backups stored **off-server** (cloud storage, not just /wp-content/backups/)
- [ ] At least one backup copy is **air-gapped**
- [ ] **Test restore performed** — download a backup and restore it to a test environment
- [ ] Backup includes: database, wp-content (uploads, themes, plugins), and wp-config.php

---

## 7. Monitoring

- [ ] **Uptime monitoring** — UptimeRobot (free), Pingdom, or similar
- [ ] **File change detection** — security plugin monitors for unexpected file changes
- [ ] **Login alerts** — get notified of admin logins
- [ ] **Google Search Console** — monitors for malware/spam warnings from Google
- [ ] **WPScan monitoring** — paid plans offer continuous vulnerability monitoring

---

## 8. Mythos-Specific Concerns

WordPress plugins are the soft underbelly. Consider:

- WordPress core is well-audited. Plugins are not.
- The average WordPress site runs 20-30 plugins, each with its own codebase, its own maintainer, and its own update cycle
- Mythos-class scanning pointed at popular WordPress plugins will find vulnerabilities that years of human review have missed
- The July 2026 Glasswing report may disclose plugin vulnerabilities — be ready to update instantly

**If you run WordPress: auto-update everything, remove what you don't need, and have a WAF in front of it.**

---

## Quick Wins (Do Today)

1. Run `wp plugin update --all` and `wp core update`
2. Delete all inactive plugins and unused themes
3. Enable auto-updates for core, plugins, and themes
4. Install and configure one security plugin (Wordfence recommended for free tier)
5. Disable XML-RPC if you don't need it
