# God Mode Admin Innovations - Implementation Plan

## Phase 1: Database & Security (Project Sentinel)
- New Table: `site_bans` (IP, Email, Reason, ExpiresAt)
- Update `api/login.js`: Check bans before allowing entry.
- Update `api/activity.js`: Detect malicious patterns (rapid clicking/login attempts).

## Phase 2: Evolution & Rewards (The Forge)
- Update `users` table: Add `xp` (INT), `badges` (JSONB), `level` (INT).
- New API: `api/forge.js`: Handle XP awards and badge assignments.
- Update Profile Modal: Show visual progress and medals.

## Phase 3: Control & Automation (Chronos & The Architect)
- New Table: `site_tasks` (TaskType, Payload, ExecuteAt, Status).
- Update `api/broadcast.js` -> `api/system-control.js`: Handle Live CSS, UI variables, and scheduled maintenance.
- Global Script: Apply God-mode overrides (Snow, Dark/Light forcing, Custom CSS).

## Phase 4: Intelligence (Neural Nexus)
- Admin UI Component: Sentiment analyzer for `site_activity` and comments.
- Demand Forecasting: Based on article view counts.

## Implementation Order
1.  **Schema Migration**: Initialize all tables in Neon.
2.  **System Core**: Expand settings and activity APIs.
3.  **Admin UI**: Massive update to `admin.html` with new control panels.
4.  **Client Sync**: Update `index.html` and `news.html` to reflect global changes.
5.  **Git Sync**: Push everything.
