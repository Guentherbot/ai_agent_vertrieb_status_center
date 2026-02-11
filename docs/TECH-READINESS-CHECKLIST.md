# TECH READINESS CHECKLIST (intern)

## Local machine
- [x] Homebrew
- [x] Node / npm
- [x] Python
- [x] VS Code + iTerm2
- [x] Postman
- [x] Ollama (optional local models)
- [ ] Docker runtime (Colima stack) functional

## Security baseline
- [x] API key from plaintext removed (Keychain-first)
- [ ] `~/.openclaw/credentials` perms hardened to 700
- [ ] gateway proxy/trusted proxy review
- [ ] incident runbook + kill switch documented

## Platform readiness
- [ ] Supabase project created
- [ ] `supabase/schema.sql` executed
- [ ] RLS validated with non-admin user
- [ ] Netlify site created and linked
- [ ] Status center MVP deployed

## Operations
- [ ] Heartbeat writer script active
- [ ] Daily health check command
- [ ] Version/update tracking enabled
- [ ] Backup/restore tested
