# Supabase Security Hardening Guide

**For teams using Supabase in the post-Mythos era.**

Supabase is built on PostgreSQL, PostgREST, GoTrue, and Realtime. Each layer has its own attack surface. This guide covers hardening specific to Supabase deployments.

---

## 1. Row Level Security (RLS)

RLS is your primary data access control. If it's wrong, everything is exposed.

### Audit Checklist

```sql
-- Find all tables WITHOUT RLS enabled
SELECT schemaname, tablename 
FROM pg_tables 
WHERE schemaname NOT IN ('pg_catalog', 'information_schema', 'auth', 'storage', 'extensions')
AND tablename NOT IN (
  SELECT tablename FROM pg_tables t
  JOIN pg_class c ON c.relname = t.tablename
  WHERE c.relrowsecurity = true
);
```

**Every table that stores user data must have RLS enabled.** No exceptions.

### Common RLS Mistakes

1. **Overly permissive anonymous policies**
```sql
-- BAD: Allows anyone to read everything
CREATE POLICY "public read" ON documents FOR SELECT USING (true);

-- GOOD: Only authenticated users can read their own
CREATE POLICY "user read own" ON documents FOR SELECT 
  USING (auth.uid() = user_id);
```

2. **Missing policies on related tables**
If `documents` has RLS but `document_comments` doesn't, attackers read comments to infer document content.

3. **Security Definer functions bypassing RLS**
```sql
-- DANGEROUS: This function runs with the function owner's privileges
CREATE OR REPLACE FUNCTION get_all_data()
RETURNS SETOF documents
LANGUAGE sql
SECURITY DEFINER  -- Bypasses RLS!
AS $$
  SELECT * FROM documents;
$$;

-- SAFE: Use SECURITY INVOKER (default in newer Supabase)
CREATE OR REPLACE FUNCTION get_user_data()
RETURNS SETOF documents
LANGUAGE sql
SECURITY INVOKER  -- Respects RLS
AS $$
  SELECT * FROM documents;
$$;
```

4. **Views with Security Definer**
```sql
-- Check for Security Definer views
SELECT viewname, definition 
FROM pg_views 
WHERE schemaname = 'public';

-- Convert to Security Invoker
ALTER VIEW my_view SET (security_invoker = on);
```

---

## 2. Edge Functions

### Security Checklist

- [ ] Every edge function validates the JWT before processing
- [ ] Input validation on all request parameters
- [ ] Error messages don't leak internal details
- [ ] Functions use service_role key only when absolutely necessary
- [ ] CORS headers are restrictive (not `*`)

```typescript
// GOOD: Validate auth in every edge function
import { createClient } from '@supabase/supabase-js'

Deno.serve(async (req) => {
  const authHeader = req.headers.get('Authorization')
  if (!authHeader) {
    return new Response('Unauthorized', { status: 401 })
  }

  const supabase = createClient(
    Deno.env.get('SUPABASE_URL')!,
    Deno.env.get('SUPABASE_ANON_KEY')!,
    { global: { headers: { Authorization: authHeader } } }
  )

  const { data: { user }, error } = await supabase.auth.getUser()
  if (error || !user) {
    return new Response('Unauthorized', { status: 401 })
  }

  // Now proceed with authenticated user context
})
```

---

## 3. API Security

Supabase exposes PostgREST directly. This is powerful but dangerous if misconfigured.

### Lock Down the API

```sql
-- Revoke direct table access from anon and authenticated roles
-- Use RLS policies instead of role-level grants
REVOKE ALL ON ALL TABLES IN SCHEMA public FROM anon;
REVOKE ALL ON ALL TABLES IN SCHEMA public FROM authenticated;

-- Then grant specific permissions that RLS will filter
GRANT SELECT ON specific_table TO authenticated;
GRANT INSERT ON specific_table TO authenticated;
```

### Rate Limiting

Supabase doesn't have built-in rate limiting. Add it at the edge:
- Cloudflare rate limiting rules
- Vercel middleware
- Custom edge function middleware

---

## 4. Authentication (GoTrue)

- [ ] Email confirmation required for new accounts
- [ ] Password minimum length and complexity enforced
- [ ] Rate limiting on login attempts
- [ ] MFA available for sensitive operations
- [ ] JWT expiration set appropriately (not too long)
- [ ] Refresh token rotation enabled
- [ ] OAuth providers configured with minimal scopes

```sql
-- Check auth configuration
SELECT * FROM auth.config;
```

---

## 5. Storage

- [ ] Storage buckets have appropriate RLS policies
- [ ] File type restrictions enforced (not just client-side)
- [ ] File size limits set
- [ ] No sensitive files in public buckets
- [ ] Upload paths don't allow directory traversal

---

## 6. Database Hardening

```sql
-- Check for functions with SECURITY DEFINER
SELECT proname, prosecdef 
FROM pg_proc 
JOIN pg_namespace ON pg_proc.pronamespace = pg_namespace.oid
WHERE nspname = 'public' AND prosecdef = true;

-- Check for overly permissive grants
SELECT grantee, privilege_type, table_name 
FROM information_schema.table_privileges 
WHERE table_schema = 'public'
ORDER BY grantee, table_name;

-- Review all triggers (potential backdoors)
SELECT trigger_name, event_manipulation, event_object_table, action_statement
FROM information_schema.triggers
WHERE trigger_schema = 'public';
```

---

## 7. Multi-Project Considerations

If you run multiple Supabase projects (common for dev/staging/prod):

- [ ] Production credentials are NOT shared with dev/staging
- [ ] Dev/staging don't have production data (use synthetic data)
- [ ] Each project has its own service role keys
- [ ] Dashboard access is restricted per-project
- [ ] Database passwords are unique per project

---

## 8. Mythos-Specific Scan Targets

When you get Mythos access, point it specifically at:

1. **All RLS policies** - can it find a bypass?
2. **Edge function auth flows** - can it find a race condition?
3. **PostgREST query patterns** - can it craft a query that leaks data?
4. **Storage access patterns** - can it access files it shouldn't?
5. **Auth flow** - can it forge a session, bypass MFA, or hijack a token?
