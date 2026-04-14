# WordPress Hardening Reference

## Critical Checks

```bash
wp core version            # Is core current?
wp plugin list --fields=name,version,update_version,status  # Any outdated?
wp theme list --fields=name,version,update_version,status   # Any outdated?
```

## Hardening Actions

1. Update everything: `wp core update && wp plugin update --all && wp theme update --all`
2. Enable auto-updates for core, plugins, and themes
3. Delete ALL inactive plugins and unused themes
4. Run WPScan: `wpscan --url https://yoursite.com --enumerate vp`
5. wp-config.php: Add `define('DISALLOW_FILE_EDIT', true);` and `define('FORCE_SSL_ADMIN', true);`
6. Disable XML-RPC (unless needed for Jetpack/mobile app)
7. Install ONE security plugin (Wordfence recommended)
8. Set file permissions: directories 755, files 644, wp-config.php 600
9. .htaccess: Add security headers, block wp-includes, disable directory browsing
10. Database: Strong unique credentials, localhost only, non-default table prefix for new installs

## Mythos Context
WordPress plugins are the #1 target. Average site runs 20-30 plugins, each with its own codebase. Mythos-class scanning of popular plugins will find vulnerabilities that years of review missed. Auto-update everything, remove what you don't need, WAF in front.
