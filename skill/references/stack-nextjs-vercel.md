# Next.js / Vercel Hardening Reference

## Critical Checks

```bash
# List all API routes
find ./src/app/api -name "route.ts" -o -name "route.js" | sort

# Check for NEXT_PUBLIC_ secrets
grep -rn "NEXT_PUBLIC_" .env* ./src/ | grep -i "secret\|key\|password\|token"
```

## Hardening Actions

1. Auth check at top of every API route (don't rely on middleware alone)
2. Input validation with Zod/similar on all endpoints
3. Restrict HTTP methods per route
4. Add security headers in middleware (CSP, HSTS, X-Frame-Options, X-Content-Type-Options)
5. Never prefix server secrets with NEXT_PUBLIC_
6. Use `server-only` package to prevent accidental client imports of server code
7. Use Vercel encrypted env vars, not .env files in production
8. Enable Vercel deployment protection for preview deployments
9. Review Vercel connected repos and integrations

## Key Vulnerability Patterns

1. Server Actions without auth checks
2. Unvalidated redirects with user-controlled URLs
3. SSRF via server-side fetch with user-controlled URLs
4. Cache poisoning in cached responses
5. Path traversal in dynamic routes
6. Prototype pollution from deep-merging user input
