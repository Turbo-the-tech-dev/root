# Phase 0 — Mainframe Discovery Checklist

> "Don't give me the brochure version. Give me the 'hidden in the JCL' version."
> — Ray Cole

---

## 📋 Executive Summary

This checklist is designed to extract **actionable intelligence** from your mainframe environment before a single migration dollar is spent. 

**Goal:** Build the "Central Nervous System" map — the real one, not the sanitized version.

**Timeline:** 2-3 weeks (depends on SysProg cooperation)

**Owner:** Infrastructure Architect + SysProg Lead

---

## 1. 🖥️ THE IRON (Hardware Inventory)

### 1.1 System Configuration

- [ ] **Machine Model**: `D M=CPU` output
  - [ ] IBM z15 / z16 / z14?
  - [ ] Unisys ClearPath? (If yes, **RED FLAG** — automated tools will fail)
  - [ ] Other (specify): _______________

- [ ] **LPAR Configuration**
  - [ ] Number of LPARs: ___
  - [ ] Dedicated vs. Shared processors
  - [ ] IFL engines count: ___
  - [ ] zIIP engines count: ___

- [ ] **DASD Configuration**
  - [ ] Total allocated space: ___ TB
  - [ ] Used space: ___ TB
  - [ ] Device types: 3390 / 9390 / other?
  - [ ] Storage subsystem: DS8000 / XIV / Other?

### 1.2 Coupling Facility

- [ ] CF Level: ___
- [ ] Coupling mode: ___
- [ ] Structures defined: ___
- [ ] Duplexing: Yes / No

### 1.3 Channel Architecture

- [ ] FICON channels: ___
- [ ] OSA ports: ___
- [ ] Crypto adapters: ___

---

## 2. 📜 THE CODEBASE (Application Inventory)

### 2.1 Language Breakdown

| Language | Lines of Code | Programs | Criticality | Notes |
|----------|---------------|----------|-------------|-------|
| COBOL | | | | |
| Assembler | | | | **RED FLAG if > 0** |
| PL/I | | | | |
| Rexx | | | | |
| CLIST | | | | |
| JCL | | | | |

### 2.2 Exit Routines (The Silent Killers)

- [ ] **Security Exits** (RACF/ACF2)
  - [ ] List all active exits: _______________
  - [ ] Language: _______________

- [ ] **CICS Exits**
  - [ ] XRNIN / XRNOT / XRNCT
  - [ ] Language: _______________

- [ ] **IMS Exits**
  - [ ] List: _______________

- [ ] **DB2 Exits**
  - [ ] Signon exit: ___
  - [ ] Authorization exit: ___

### 2.3 Online Systems

- [ ] **CICS Regions**
  - [ ] Count: ___
  - [ ] Versions: ___
  - [ ] Transactions: ___
  - [ ] Programs: ___

- [ ] **IMS Regions**
  - [ ] DL/I databases: ___
  - [ ] BMP regions: ___
  - [ ] MPP regions: ___

- [ ] **Batch Regions**
  - [ ] JES2 / JES3: ___
  - [ ] Active jobs (avg/day): ___

---

## 3. 💾 THE DATA GRAVITY (Database & Storage)

### 3.1 Database Inventory

| Database | Type | Size (GB) | Tables/Files | Daily Transactions | Criticality |
|----------|------|-----------|--------------|-------------------|-------------|
| | DB2 / IMS / Other | | | | |

### 3.2 VSAM Files

- [ ] **Total VSAM datasets**: ___
- [ ] **Record-level sharing enabled**: Yes / No
- [ ] **High-activity files** (>1000 updates/day):
  - [ ] List: _______________

### 3.3 Data Sync Requirements

For each critical file/database:

| Dataset | Sync Frequency | Max Latency | Conflict Resolution |
|---------|----------------|-------------|---------------------|
| | Real-time / Batch | ___ ms | ___ |

---

## 4. 🗓️ THE SCHEDULER (Job Dependencies)

### 4.1 Scheduler Software

- [ ] CA-7 / Control-M / OPC / Other: ___
- [ ] Version: ___

### 4.2 Job Statistics (Last 6 Months)

- [ ] **Total jobs defined**: ___
- [ ] **Active jobs (daily)**: ___
- [ ] **Job dependencies**: ___ relationships
- [ ] **Calendar exceptions**: ___ per year

### 4.3 Top 10 CPU Consumers (Last Month)

| Rank | Job Name | CPU Time | Frequency | Owner | Notes |
|------|----------|----------|-----------|-------|-------|
| 1 | | | | | |
| 2 | | | | | |
| 3 | | | | | |
| 4 | | | | | |
| 5 | | | | | |
| 6 | | | | | |
| 7 | | | | | |
| 8 | | | | | |
| 9 | | | | | |
| 10 | | | | | |

### 4.4 Batch Window Analysis

- [ ] **Current batch window**: ___:___ to ___:___
- [ ] **Peak CPU time**: ___:___
- [ ] **Critical path jobs**: _______________
- [ ] **Jobs that cannot be delayed**: _______________

---

## 5. 🔀 SORT ROUTINES (The I/O Monsters)

### 5.1 Sort Usage

- [ ] **DFSORT / SyncSort version**: ___
- [ ] **Daily sort volume**: ___ TB
- [ ] **Largest sort job**: ___ GB, ___ records

### 5.2 Sort-Heavy Jobs

| Job Name | Input Size | Output Size | Sort Fields | Frequency |
|----------|------------|-------------|-------------|-----------|
| | | | | |

---

## 6. 🔌 MQ SERIES & INTEGRATION

### 6.1 Queue Managers

- [ ] **QMGR count**: ___
- [ ] **Version**: ___
- [ ] **Channels defined**: ___

### 6.2 Queue Inventory

| Queue Name | Type | Max Depth | Avg Messages/Day | Connected Apps |
|------------|------|-----------|------------------|----------------|
| | Local / Remote / Alias | | | |

### 6.3 External Integrations

| System | Protocol | Frequency | Data Volume | Owner |
|--------|----------|-----------|-------------|-------|
| | MQ / FTP / Connect:Direct | | | |

---

## 7. 📡 EXTERNAL INTERFACES (The FTP Problem)

### 7.1 Inbound Feeds

| Source | Method | Frequency | Format | Volume | Criticality |
|--------|--------|-----------|--------|--------|-------------|
| | FTP / SFTP / CD / MQ | | Flat file / XML / JSON | | |

### 7.2 Outbound Feeds

| Destination | Method | Frequency | Format | Volume | SLA |
|-------------|--------|-----------|--------|--------|-----|
| | | | | | |

### 7.3 Vendor Dependencies

| Vendor | Service | Integration Point | Contract End | Exit Strategy |
|--------|---------|-------------------|--------------|---------------|
| | | | | |

---

## 8. 📊 MIPS & COST ANALYSIS

### 8.1 MIPS Consumption (Last 6 Months)

| Month | Avg MIPS | Peak MIPS | Cost ($K) | Notes |
|-------|----------|-----------|-----------|-------|
| | | | | |

### 8.2 Cost Per Transaction

- [ ] **Total monthly cost**: $___K
- [ ] **Total monthly transactions**: ___M
- [ ] **Cost per transaction**: $___

### 8.3 Growth Trends

- [ ] **MIPS growth (YoY)**: ___%
- [ ] **Data growth (YoY)**: ___%
- [ ] **Transaction growth (YoY)**: ___%

---

## 9. 🔐 SECURITY & COMPLIANCE

### 9.1 Security Software

- [ ] RACF / ACF2 / Top Secret: ___
- [ ] Version: ___

### 9.2 Compliance Requirements

- [ ] PCI-DSS: Yes / No / Scope: ___
- [ ] SOX: Yes / No / Controls: ___
- [ ] GDPR: Yes / No / Data elements: ___
- [ ] Other: ___

### 9.3 Encryption

- [ ] Data at rest: Yes / No
- [ ] Data in transit: Yes / No
- [ ] Crypto hardware: CPACF / Crypto Express

---

## 10. 🎯 THE STRANGLER STRATEGY (Wave 1 Candidates)

### 10.1 Sacrificial Lamb Criteria

A good Wave 1 candidate:

- [ ] **Low criticality** (not core ledger)
- [ ] **Batch-oriented** (runs once/day or less)
- [ ] **No real-time dependencies**
- [ ] **Clear ownership** (single team)
- [ ] **Documented** (requirements exist)
- [ ] **Test coverage** (test cases available)

### 10.2 Wave 1 Candidates

| System | Description | Criticality | Complexity | Effort (weeks) | Risk |
|--------|-------------|-------------|------------|----------------|------|
| | | Low/Med/High | Low/Med/High | | Low/Med/High |

### 10.3 API Wrapper Candidates (CICS Transactions)

| Transaction | Description | Calls/Day | Response Time | Priority |
|-------------|-------------|-----------|---------------|----------|
| | | | | |

---

## 📋 DATA COLLECTION COMMANDS

### For SysProgs (Copy/Paste Ready)

```jcl
//MIPSRPT   JOB ...
//STEP1     EXEC PGM=RMFMON
//SYSPRINT  DD SYSOUT=*
//SYSIN     DD *
  INTERVAL=1H
  DURATION=24H
/*
```

```jcl
//TOPCPU    JOB ...
//STEP1     EXEC PGM=IEBGENER
//SYSIN     DD DUMMY
//SYSPRINT  DD SYSOUT=*
//SYSUT1    DD DISP=SHR,DSN=SMF.DATA.SET
//SYSUT2    DD SYSOUT=*
```

```bash
# For DB2
db2 "SELECT TABSCHEMA, TABNAME, CARD, NPAGES FROM SYSCAT.TABLES ORDER BY NPAGES DESC FETCH FIRST 50 ROWS ONLY"
```

---

## ✅ DELIVERABLES

At the end of Phase 0, you should have:

1. [ ] **System Map** — Visual diagram of all components and dependencies
2. [ ] **Data Flow Diagram** — How data moves through the system
3. [ ] **Job Dependency Graph** — From scheduler export
4. [ ] **MIPS/Cost Baseline** — 6-month trend
5. [ ] **Wave 1 Candidate List** — 3-5 systems ready for migration
6. [ ] **Risk Register** — Top 10 risks with mitigation strategies
7. [ ] **Gantt Chart** — 18-24 month roadmap with milestones

---

## 🚨 RED FLAGS (Stop & Escalate)

If you find any of these, **pause and escalate**:

- [ ] Assembler code in exit routines (no automated tool handles this)
- [ ] Undocumented COBOL programs (>10,000 lines, no source)
- [ ] Single-person knowledge (only one person knows how it works)
- [ ] Vendor-locked interfaces (proprietary protocols)
- [ ] Real-time sync requirements (<100ms latency)
- [ ] Compliance blockers (data residency, encryption requirements)

---

*Template Version: 1.0*
*Last Updated: 2026-02-28*
*Marcus Hale + Ray Cole approved — "Measure twice, migrate once."*
