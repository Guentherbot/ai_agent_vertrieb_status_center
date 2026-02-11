# CTO Roadmap (14 Tage) — AI-AGENT-VERTRIEB

## North Star
- **Angebot v1:** „Wir liefern deinen persönlichen AI-Agenten in 5 Stunden.“
- **Go-Live Kundenstart:** ab **17.02.2026**
- **Monatsziel:** **>= 10.000 €**
- Sprache: **Deutsch**

## Harte Prinzipien
1. Speed > Perfektion (aber Security/DSGVO nicht brechen)
2. Erst verkaufen, dann verfeinern
3. Alles wiederholbar machen (Runbooks + Templates)
4. Nur Betriebsdaten zentral sammeln (keine Chatinhalte)

---

## Sprint 0 (heute + morgen)
### Ziel
Tech-Basis stabil + verkaufsfähiger MVP-Stack.

### Deliverables
- [x] Status-Center live (Netlify)
- [x] Supabase Monitoring-Schema + Heartbeat
- [x] Login-only via Supabase Auth
- [ ] CRM-Schema live (Lead-Pipeline)
- [ ] Sales-Assets v1 (1 Angebotstext + 1 DM-Sequenz + 1 Landing)

---

## Sprint 1 (Tag 1–3)
### Ziel
Lead-Maschine starten + erster Pipeline-Eingang.

### Deliverables
1. **CRM v1 live** (Supabase)
   - leads, lead_touchpoints, deals, tasks
   - Pipeline: NEW → CONTACTED → REPLIED → QUALIFIED → CALL_BOOKED → WON/LOST
2. **Outreach v1 (quick & dirty)**
   - 1x Insta-Post
   - 1x X/Twitter-Post
   - 1x Cold-DM Script (DE)
3. **Fulfillment Runbook v1**
   - 5-Stunden-Install-Checkliste
   - Safety baseline (Keychain, RLS, Freigabe-Regeln)

---

## Sprint 2 (Tag 4–7)
### Ziel
Erste Calls + erste bezahlte Setups.

### Deliverables
1. **Qualifizierungsskript (15 Min Call)**
2. **Onboarding-Template**
   - Kundenziele, Kanäle, gewünschte Automationen
3. **Install Package v1**
   - Standard-Agent + 3 Kern-Workflows
4. **KPI-Board**
   - Leads neu / Replies / Calls / Abschlüsse / Umsatz

---

## Sprint 3 (Tag 8–14)
### Ziel
Wiederholbares Delivery-System + mehr Abschlüsse.

### Deliverables
1. **Produktisierte Pakete**
   - Setup (einmalig)
   - Retainer (klein, Updates + Monitoring)
2. **Incident-Management**
   - Alerts, Fehlerklassen, Restart-Flow
3. **Ops-Automation**
   - tägliche Pipeline-Tasks automatisch erzeugen

---

## KPI-Minimum (wöchentlich)
- Leads neu: 30
- Erstkontakte: 30
- Antworten: 8+
- Calls: 4+
- Setups verkauft: 2+

---

## Risiken & Gegenmaßnahmen
- **Zu breite Zielgruppe („jeder mit Geld“)** → Messaging verwässert
  - Gegenmaßnahme: Erstansprache auf „Inhaber/Selbstständige mit akuter Zeitnot“ fokussieren
- **Tech drift/komplex**
  - Gegenmaßnahme: 1 Standard-Stack, keine Tool-Explosion
- **Datenschutz-Unklarheit**
  - Gegenmaßnahme: keine Inhalte im Control Center, nur Betriebsmetriken
