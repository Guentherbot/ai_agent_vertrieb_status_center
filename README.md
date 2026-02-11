# AI-AGENT-VERTRIEB (Tech Ready Stack)

Interner Build-Ordner für unser Agent-Operations-Setup.

## Ziel
- Technische Basis aufsetzen (lokal + Supabase + Netlify)
- Status-Center MVP ohne Inhaltsdaten/PII
- Security-First mit minimaler Datenhaltung

## Komponenten
- `supabase/schema.sql` → DB-Schema + RLS
- `status-center/` → leichtes Netlify-Frontend (MVP)
- `docs/` → Policies + Setup-Runbooks

## Datenschutz-Prinzip
Nur Betriebsdaten (Health/Version/Fehlerklassen/Kosten-Aggregate), keine Chatinhalte, keine personenbezogenen Message-Daten.
