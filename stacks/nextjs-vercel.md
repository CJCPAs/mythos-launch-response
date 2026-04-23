# Next.js + Vercel Security Hardening Guide

**For teams deploying Next.js applications on Vercel in the post-Mythos era.**

---

## 1. API Routes

Every API route is a potential attack surface.

### Audit Every Route

```bash
# List all API routes
find ./src/app/api -name "route.ts" -o -name "route.js" | sort
```

For each route, verify:
- [ ] Authentication check at the top (don't rely on middleware alone)
- [ ] Input validation on all parameters (use Zod or similar)
- [ ] Appropriate HTTP methods restricted (don't allow GET on mutation endpoints)
- [ ] Rate limiting applied
- [ ] Error responses don't leak internal details

```typescript
// GOOD: Defensive API route pattern
import { NextRequest, NextResponse } from 'next/server'
import { z } from 'zod'
import { getServerSession } from 'next-auth'

const RequestSchema = z.object({
  id: z.string().uuid(),
  action: z.enum(['approve', 'reject']),
})

export async function POST(req: NextRequest) {
  // 1. Auth check
  const session = await getServerSession()
  if (!session?.user) {
    return NextResponse.json({ error: 'Unauthorized' }, { status: 401 })
  }

  // 2. Input validation
  const body = await req.json().catch(() => null)
  const parsed = RequestSchema.safeParse(body)
  if (!parsed.success) {
    return NextResponse.json({ error: 'Invalid request' }, { status: 400 })
  }

  // 3. Authorization check (not just authentication)
  const hasPermission = await checkUserPermission(session.user.id, parsed.data.id)
  if (!hasPermission) {
    return NextResponse.json({ error: 'Forbidden' }, { status: 403 })
  }

  // 4. Execute with validated, authorized data only
  try {
    const result = await processAction(parsed.data)
    return NextResponse.json(result)
  } catch (error) {
    // 5. Don't leak error details
    console.error('Action failed:', error)
    return NextResponse.json({ error: 'Internal error' }, { status: 500 })
  }
}
```

---

## 2. Middleware Security

```typescript
// middleware.ts - defense in depth
import { NextResponse } from 'next/server'
import type { NextRequest } from 'next/server'

export function middleware(request: NextRequest) {
  const response = NextResponse.next()

  // Security headers
  response.headers.set('X-Frame-Options', 'DENY')
  response.headers.set('X-Content-Type-Options', 'nosniff')
  response.headers.set('Referrer-Policy', 'strict-origin-when-cross-origin')
  response.headers.set('Permissions-Policy', 'camera=(), microphone=(), geolocation=()')
  response.headers.set(
    'Content-Security-Policy',
    "default-src 'self'; script-src 'self' 'unsafe-inline' 'unsafe-eval'; style-src 'self' 'unsafe-inline';"
  )
  response.headers.set(
    'Strict-Transport-Security',
    'max-age=31536000; includeSubDomains; preload'
  )

  return response
}
```

---

## 3. Environment Variables

```bash
# Check what's exposed to the client
grep -rn "NEXT_PUBLIC_" .env* ./src/

# Verify no server-side secrets have NEXT_PUBLIC_ prefix
# These are EXPOSED to the browser:
# NEXT_PUBLIC_SUPABASE_URL - OK (public by design)
# NEXT_PUBLIC_SUPABASE_ANON_KEY - OK (public by design)
# NEXT_PUBLIC_STRIPE_SECRET_KEY - CRITICAL VULNERABILITY
```

### Rules
- NEVER prefix server-side secrets with `NEXT_PUBLIC_`
- Use `server-only` package to prevent accidental client imports
- Verify build logs don't contain secrets
- Use Vercel's environment variables — **and mark secrets as `sensitive`, not just `encrypted`** (see below)

### `sensitive` vs `encrypted` on Vercel (lesson from the April 2026 Vercel/Context.ai breach)

Vercel stores three classes of environment variables:

| Type | Storage | Readable via API? | Breach exposure |
|------|---------|:-:|:-:|
| `plain` | Unencrypted | Yes | **Fully exposed** |
| `encrypted` | Encrypted at rest | **Yes — the API can read the value** | **At risk** |
| `sensitive` | Encrypted, non-readable | **No — the API cannot read the value** | **Protected** |

The Vercel April 2026 bulletin explicitly stated that environment variables marked `sensitive` were not accessed; encrypted (but non-sensitive) variables were. Many developers assume "encrypted" equals "protected." **It does not.** Encrypted values are readable through the Vercel API by anyone with account-level access.

**Rule:** every real secret (API keys, service-role keys, webhook secrets, signing keys) should be marked `sensitive`. Not just `encrypted`. Not just stored in Vercel's UI.

### Audit your own Vercel env vars today

Use the [GitGuardian post-Vercel-incident guidance](https://blog.gitguardian.com/vercel-april-2026-incident-non-sensitive-environment-variables-need-investigation-too/) as a starting playbook:

```bash
# 1. Pull all env vars locally across every environment
vercel env pull .env.production --environment=production
vercel env pull .env.preview --environment=preview
vercel env pull .env.development --environment=development

# 2. Scan them for secrets that are not flagged sensitive
ggshield secret scan path .env.production .env.preview .env.development

# 3. For any real secret not marked sensitive: rotate + re-add as sensitive
```

Setting `sensitive` currently requires the dashboard or the Vercel REST API — the CLI (`vercel env add`) does not have a `--sensitive` flag as of CLI v50.37.

### The `sk_live_*` in preview/dev footgun

A common Next.js/Vercel pattern is having the same environment variable value across `production`, `preview`, and `development` scopes "to keep things simple." This is how live Stripe keys end up reachable from preview deployments — which means a preview URL (discoverable via GitHub PR comments, Twitter, etc.) can charge real cards.

Audit rule: `STRIPE_SECRET_KEY` on preview/dev should be `sk_test_*`, not `sk_live_*`. Same principle for any production-vs-test vendor key pair (Resend, Postmark, Twilio, etc.).

---

## 4. Server Components vs Client Components

```typescript
// Server components can safely access secrets
// app/dashboard/page.tsx (Server Component)
import { headers } from 'next/headers'
import 'server-only' // Prevents importing into client components

async function DashboardPage() {
  // This is safe - runs only on the server
  const data = await fetch(process.env.INTERNAL_API_URL, {
    headers: { Authorization: `Bearer ${process.env.API_SECRET}` }
  })
  // ...
}
```

---

## 5. Vercel-Specific Configuration

### vercel.json Security

```json
{
  "headers": [
    {
      "source": "/api/(.*)",
      "headers": [
        { "key": "X-Content-Type-Options", "value": "nosniff" },
        { "key": "X-Frame-Options", "value": "DENY" }
      ]
    }
  ],
  "rewrites": [],
  "redirects": []
}
```

### Deployment Protection
- Enable Vercel Authentication for preview deployments
- Set up Deployment Protection to **"Standard" at minimum** on production projects
- Rotate any Deployment Protection tokens after an account security event
- Use Vercel Firewall if available on your plan

### OAuth and third-party integration hygiene (post-Context.ai/Vercel breach)

The April 2026 Vercel breach originated with a compromised third-party AI tool (Context.ai) that had OAuth access to a Vercel employee's Google Workspace — not a direct attack on Vercel. Same pattern applies to your Vercel account.

**Audit your Vercel integrations:**
- https://vercel.com/account/integrations — review every third-party OAuth integration. Remove anything you don't actively use.
- https://vercel.com/account/tokens — review all personal and team API tokens. Rotate anything older than 90 days or held by a service you no longer use.
- **Teams settings → Members** — confirm only active humans have access. Remove former contractors and stale service accounts.
- **Connected Git integrations** — GitHub/GitLab/Bitbucket. Verify scope is repo-level, not org-wide admin.

**Before authorizing any new AI tool to connect to your Vercel account**, run the four-channel check in [docs/12-supply-chain-safety.md](../docs/12-supply-chain-safety.md#four-channel-vendor-check): DNS/firewall logs, browser history, email invitations, and identity-provider audit logs.

### Long-term: move secrets out of Vercel

Vercel-direct env vars are convenient but concentrate risk. After a breach you are stuck rotating everything manually. Consider migrating to a dedicated secret manager that syncs to Vercel:

- **[Doppler](https://www.doppler.com/)** — native Vercel integration, auto-sync, audit logs, rotation is a single command
- **[Infisical](https://infisical.com/)** — open-source option, self-hostable
- **[1Password Secrets Automation](https://1password.com/developers/secrets-automation)** — if already on 1Password
- **[HashiCorp Vault](https://www.hashicorp.com/en/products/vault)** — heavyweight, appropriate for regulated workloads

With a secret manager in front of Vercel, a compromised Vercel account is a smaller blast radius — secrets live in the manager, Vercel only ever sees short-lived synced copies, and rotation is one command instead of thirty.

---

## 6. Common Next.js Vulnerabilities to Scan For

1. **Server Actions without auth** - Next.js Server Actions can be called directly
2. **Unvalidated redirects** - `redirect()` with user-controlled URLs
3. **SSRF via fetch** - server-side fetch with user-controlled URLs
4. **Cache poisoning** - manipulating cached responses
5. **Path traversal** - dynamic routes that access the filesystem
6. **Prototype pollution** - deep merging user input into objects
