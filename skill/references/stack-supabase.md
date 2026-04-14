# Supabase Hardening Reference

## Critical Checks

```sql
-- Tables without RLS
SELECT schemaname, tablename FROM pg_tables
WHERE schemaname NOT IN ('pg_catalog','information_schema','auth','storage','extensions')
AND tablename NOT IN (SELECT t.tablename FROM pg_tables t JOIN pg_class c ON c.relname = t.tablename WHERE c.relrowsecurity = true);

-- Security Definer functions (bypass RLS)
SELECT proname, prosecdef FROM pg_proc JOIN pg_namespace ON pg_proc.pronamespace = pg_namespace.oid
WHERE nspname = 'public' AND prosecdef = true;

-- Overly permissive grants
SELECT grantee, privilege_type, table_name FROM information_schema.table_privileges WHERE table_schema = 'public';
```

## Hardening Actions

1. Enable RLS on ALL tables with user data — no exceptions
2. Audit RLS policies for USING(true) (overly permissive)
3. Convert Security Definer functions to Security Invoker
4. Convert Security Definer views: `ALTER VIEW my_view SET (security_invoker = on)`
5. Validate JWT in every edge function before processing
6. Restrict CORS (not `*`)
7. Revoke direct table access from anon/authenticated, use RLS
8. Add rate limiting at edge (Cloudflare, Vercel middleware)
9. Enable email confirmation, enforce password complexity
10. Enable refresh token rotation
11. Audit storage bucket policies and file type restrictions

## Mythos Context
Supabase exposes PostgREST directly. RLS is the primary defense. SECURITY DEFINER functions are the most common bypass. Scan all RLS policies with Mythos when available.
