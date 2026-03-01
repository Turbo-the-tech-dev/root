# Mainframe Migration — Sector 20

> "We're not moving the mainframe. We're hollowing it out while it's still running."

---

## 🏛️ Mission Statement

This sector contains the **strategic blueprint** for migrating legacy mainframe workloads to cloud-native infrastructure using the **Strangler Fig Pattern**.

**Not a lift-and-shift. Not a rewrite. A surgical extraction.**

---

## 📁 Directory Structure

```
sectors/20-mainframe-migration/
├── PHASE0_CHECKLIST.md      # Discovery checklist (this file)
├── phase1-sacrificial-lamb/ # Wave 1 migration target
├── phase2-api-wrapper/      # CICS transaction wrapping
├── phase3-core-ledger/      # The big move (last)
└── artifacts/               # Diagrams, Gantt charts, reports
```

---

## 🎯 The Ray Cole Strategy

### Phase 0: Discovery (2-3 weeks)

**Goal:** Build the "Central Nervous System" map.

**Deliverables:**
- MIPS usage reports (6 months)
- Top 10 CPU-consuming jobs
- MQ Series endpoints
- External vendor FTP inventory
- Scheduler dependency graph

**Tool:** `PHASE0_CHECKLIST.md` — hand this to your SysProgs.

---

### Phase 1: Sacrificial Lamb (4-6 weeks)

**Goal:** Prove the plumbing works without killing the patient.

**Candidate Criteria:**
- Low criticality (not core ledger)
- Batch-oriented (runs once/day)
- No real-time dependencies
- Clear ownership

**Target:** AWS Batch / Lambda / Azure Functions

---

### Phase 2: API Wrapper (8-12 weeks)

**Goal:** Make the mainframe look like a cloud service.

**Approach:**
- z/OS Connect or MuleSoft layer over CICS
- REST/SOAP wrappers for transactions
- Gradual traffic shifting to cloud equivalents

**Success Metric:** 50% of transactions routed through API layer

---

### Phase 3: Core Ledger (18-24 weeks)

**Goal:** The big move — only after Phases 1-2 prove the pattern.

**Approach:**
- Dual-write to cloud database
- Parallel run (mainframe + cloud)
- Cutover during maintenance window
- Rollback plan ready

**Risk Mitigation:** 
- Data sync in both directions
- Circuit breakers at every layer
- 24/7 war room during cutover

---

## 🚨 Red Flags (Showstoppers)

| Flag | Description | Mitigation |
|------|-------------|------------|
| 🔴 Assembler exits | Automated tools will fail | Manual rewrite required |
| 🔴 Undocumented COBOL | No source, no specs | Reverse engineer + test harness |
| 🔴 Single-point knowledge | Only 1 person knows it | Knowledge transfer before migration |
| 🔴 Real-time sync (<100ms) | Cloud latency will break it | Edge caching / pre-compute |
| 🔴 Vendor-locked protocols | Proprietary interfaces | Gateway abstraction layer |

---

## 📊 Migration Roadmap (Gantt Overview)

```
Week  0-2:  Phase 0 Discovery ████████████████████
Week  3-8:  Phase 1 Sacrificial Lamb     ████████████████████████████████
Week  9-20: Phase 2 API Wrapper                          ████████████████████████████████████████████████
Week 21-44: Phase 3 Core Ledger                                                              ████████████████████████████████████████████████████████████████████
```

---

## 🛠️ Tools & Technologies

| Category | Tool | Purpose |
|----------|------|---------|
| **Discovery** | LSL, PlanX | Mainframe analysis |
| **API Layer** | z/OS Connect, MuleSoft | CICS wrapping |
| **Migration** | Blu Insights, AWS MMT | Code analysis |
| **Data Sync** | CDC, GoldenGate | Real-time replication |
| **Testing** | Compuware, BMC | Regression testing |

---

## 📋 Key Metrics

| Metric | Baseline | Target | Status |
|--------|----------|--------|--------|
| MIPS consumption | ___ | -40% | 🔄 |
| Cost per transaction | $___ | -30% | 🔄 |
| Batch window | ___:___ | -50% | 🔄 |
| Cloud coverage | 0% | 80% | 🔄 |

---

## 🔗 Related Sectors

| Sector | Purpose |
|--------|---------|
| 08-AWS | Cloud infrastructure (Terraform) |
| 06-Firestore | Data layer for migrated apps |
| 19-Expo | Mobile front-end for wrapped APIs |
| 17-Flutter | Web front-end for wrapped APIs |

---

## 📞 Escalation Path

| Issue | Owner | Contact |
|-------|-------|---------|
| SysProg resistance | Infrastructure Director | ___ |
| Vendor negotiations | Procurement | ___ |
| Compliance concerns | Security Team | ___ |
| Technical blockers | Lead Architect | ___ |

---

*Last Updated: 2026-02-28*
*Marcus Hale + Ray Cole approved — "The dinosaur dies slowly, one organ at a time."*
