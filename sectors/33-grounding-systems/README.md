# Sector 33 — Electrical Grounding & Bonding Systems

> "Ground It Right, or Light It Up." — The Imperial Ground Rod

---

## ⚡ Overview

**Comprehensive grounding and bonding reference, calculations, and compliance tools.**

Purpose:
- NEC Article 250 compliance
- Grounding electrode design
- Bonding jumper sizing
- Equipment grounding calculations
- System grounding methods
- Fault current analysis

---

## 📋 NEC Article 250 Reference

### Key Sections

| Section | Topic | Requirement |
|---------|-------|-------------|
| **250.4** | General Requirements | Performance criteria for grounding |
| **250.20** | AC Systems to Ground | When grounding is required |
| **250.24** | Grounding Service-Supplied Systems | Main bonding jumper |
| **250.28** | Main Bonding Jumper & System Jumper | Sizing requirements |
| **250.30** | Grounding Separately Derived Systems | Transformer grounding |
| **250.50** | Grounding Electrode System | Required electrodes |
| **250.52** | Grounding Electrodes | Types of electrodes |
| **250.64** | Grounding Electrode Conductor | Installation requirements |
| **250.66** | AC Grounding Electrode Conductor | Sizing requirements |
| **250.102** | Bonding Conductors & Equipment | Size & connection |
| **250.122** | Equipment Grounding Conductor | Sizing based on OCPD |

---

## 🔌 Grounding Electrode Types (250.52)

### Natural Electrodes

| Type | Minimum Size | Installation |
|------|--------------|--------------|
| **Metal Underground Water Pipe** | 20 ft contact | Supplemental electrode required |
| **Metal Frame of Building** | Per 250.52(A)(2) | Connection per 250.68 |
| **Concrete-Encased Electrode** | 20 ft, ½" rebar | In concrete footing/foundation |

### Manufactured Electrodes

| Type | Minimum Size | Installation |
|------|--------------|--------------|
| **Ground Ring** | 2 AWG bare copper | 2.5 ft deep, 20 ft length |
| **Rod Electrode** | 5/8" steel, ½" copper | 8 ft length, full contact |
| **Pipe Electrode** | ¾" trade size | 8 ft length, full contact |
| **Plate Electrode** | 2 ft² surface area | 2.5 ft deep |

---

## 📏 Grounding Electrode Conductor (GEC) Sizing

### Based on Service Entrance Conductors (250.66)

| Service Conductors | Minimum GEC |
|--------------------|-------------|
| 2 AWG or smaller | 8 AWG Cu / 6 AWG Al |
| 1 AWG or 1/0 AWG | 6 AWG Cu / 4 AWG Al |
| 2/0 AWG or 3/0 AWG | 4 AWG Cu / 2 AWG Al |
| Over 3/0 AWG to 350 kcmil | 2 AWG Cu / 1/0 AWG Al |
| Over 350 kcmil to 600 kcmil | 1/0 AWG Cu / 3/0 AWG Al |
| Over 600 kcmil | 2/0 AWG Cu / 4/0 AWG Al |

### Based on Overcurrent Protection (250.122)

| OCPD Rating | Equipment Grounding Conductor |
|-------------|-------------------------------|
| 15A | 14 AWG Cu |
| 20A | 12 AWG Cu |
| 30A | 10 AWG Cu |
| 40A | 10 AWG Cu |
| 60A | 10 AWG Cu |
| 100A | 8 AWG Cu |
| 200A | 6 AWG Cu |
| 400A | 3 AWG Cu |
| 600A | 1 AWG Cu |
| 800A | 1/0 AWG Cu |
| 1000A | 2/0 AWG Cu |
| 1200A | 3/0 AWG Cu |
| 1600A | 4/0 AWG Cu |
| 2000A | 250 kcmil Cu |
| 2500A | 350 kcmil Cu |
| 3000A | 400 kcmil Cu |
| 4000A | 600 kcmil Cu |

---

## 🔧 Grounding Methods by System

### Service Entrance Grounding

```
Utility Transformer
       │
       ▼
Service Disconnect
       │
       ├── Main Bonding Jumper (sized per 250.28)
       │
       ├── Grounding Electrode Conductor (sized per 250.66)
       │
       └── Grounding Electrode System
              ├── Metal Water Pipe (if available)
              ├── Concrete-Encased Electrode (Ufer)
              └── Supplemental Electrode (rod/pipe/plate)
```

### Separately Derived System (Transformer)

```
Primary Service
       │
       ▼
Transformer
       │
       ├── X0 (Neutral) Terminal
       │
       ├── System Bonding Jumper (sized per 250.28)
       │
       ├── Grounding Electrode Conductor (sized per 250.66)
       │
       └── Local Grounding Electrode
```

### Equipment Grounding

```
Panelboard
       │
       ├── Equipment Grounding Conductor (sized per 250.122)
       │
       ├── All Metal Enclosures
       │
       └── Equipment Grounding Terminals
```

---

## 🧮 Grounding Calculators

### Main Bonding Jumper Calculator

```bash
# Usage: grounding mbj --service-amps 400 --conductor 600kcmil

Input:
- Service Rating: 400A
- Largest Ungrounded Conductor: 600 kcmil Cu

Output:
- Main Bonding Jumper: 2/0 AWG Cu (12.5% of 600 kcmil)
- Minimum Size: 2/0 AWG Cu per 250.28(D)
```

### Grounding Electrode Conductor Calculator

```bash
# Usage: grounding gec --service-entrance 500kcmil

Input:
- Service Entrance Conductors: 500 kcmil Cu

Output:
- GEC Minimum: 1/0 AWG Cu per Table 250.66
- Recommended: 2/0 AWG Cu (for future expansion)
```

### Equipment Grounding Conductor Calculator

```bash
# Usage: grounding egc --ocpd 400A

Input:
- Overcurrent Protection: 400A

Output:
- EGC Minimum: 3 AWG Cu per Table 250.122
- For Parallel Conductors: 3 AWG Cu per conduit
```

### Ground Rod Resistance Calculator

```bash
# Usage: grounding rod-resistance --soil-resistivity 100 --length 8 --diameter 0.625

Input:
- Soil Resistivity: 100 ohm-meters
- Rod Length: 8 ft
- Rod Diameter: 5/8"

Output:
- Single Rod Resistance: ~25 ohms
- NEC Requirement: 25 ohms or less (250.56)
- If >25 ohms: Install supplemental electrode
```

---

## 📊 Grounding System Testing

### Required Tests

| Test | Instrument | Acceptable Value |
|------|------------|------------------|
| **Ground Electrode Resistance** | Ground Resistance Tester | ≤25 ohms (250.56) |
| **Continuity of Equipment Ground** | Low-Resistance Ohmmeter | ≤1 ohm |
| **Ground Fault Path Impedance** | Ground Fault Tester | Per 250.4(A)(5) |
| **Soil Resistivity** | Soil Resistivity Tester | Design basis |

### Test Procedures

#### Ground Rod Resistance Test (Fall-of-Potential Method)

```
1. Disconnect grounding electrode from system
2. Install test probes at specified distances
3. Apply test current between electrode and current probe
4. Measure voltage between electrode and potential probe
5. Calculate resistance: R = V/I
6. Acceptable: ≤25 ohms (or install supplemental electrode)
```

#### Equipment Grounding Continuity Test

```
1. De-energize system
2. Connect tester to equipment enclosure
3. Measure resistance to grounding bus
4. Acceptable: ≤1 ohm (NEC recommends low impedance)
```

---

## 🔧 Installation Requirements

### Ground Rod Installation (250.53)

| Requirement | Specification |
|-------------|---------------|
| **Length** | Minimum 8 ft |
| **Depth** | Minimum 8 ft (top at grade or below) |
| **Spacing** | Minimum 6 ft apart (if multiple) |
| **Connection** | Exothermic or listed connector |
| **Protection** | Protect from physical damage |

### Concrete-Encased Electrode (Ufer) (250.52(A)(3))

| Requirement | Specification |
|-------------|---------------|
| **Conductor** | ½" rebar or 4 AWG Cu minimum |
| **Length** | Minimum 20 ft |
| **Location** | In concrete footing/foundation |
| **Connection** | Accessible for testing |

### Grounding Electrode Conductor Installation (250.64)

| Requirement | Specification |
|-------------|---------------|
| **Protection** | Protect from physical damage |
| **Securing** | Secure at intervals ≤5 ft |
| **Splices** | Only with irreversible compression |
| **Termination** | Listed connector, accessible |

---

## ⚠️ Common Violations

| Violation | NEC Reference | Correction |
|-----------|---------------|------------|
| **No supplemental electrode** | 250.53(A)(2) | Install second rod |
| **GEC too small** | 250.66 | Upsize per table |
| **EGC not sized for OCPD** | 250.122 | Recalculate, replace |
| **Main bonding jumper missing** | 250.28 | Install per 250.28(D) |
| **Neutral-ground bond at subpanel** | 250.142 | Remove bond, install separate EGC |
| **GEC spliced with wire nut** | 250.64(C) | Use irreversible compression |
| **Ground rod not 8 ft deep** | 250.53(G) | Drive deeper or install at angle |

---

## 📋 Grounding Checklist

### Service Entrance

- [ ] Main bonding jumper installed and sized
- [ ] Grounding electrode conductor sized per 250.66
- [ ] Grounding electrode system complete
- [ ] Water pipe bond within 5 ft of entrance
- [ ] Supplemental electrode installed (if required)
- [ ] All connections accessible and listed
- [ ] GEC protected from physical damage

### Separately Derived Systems

- [ ] System bonding jumper installed
- [ ] Grounding electrode conductor run
- [ ] Local grounding electrode installed
- [ ] Neutral isolated from equipment ground
- [ ] Equipment grounding conductor sized

### Feeders & Branch Circuits

- [ ] Equipment grounding conductor installed
- [ ] EGC sized per 250.122
- [ ] All enclosures bonded
- [ ] No neutral-ground bonds downstream of service
- [ ] Continuity verified

---

## 🔗 Related Sectors

| Sector | Purpose |
|--------|---------|
| **26-Hospital-API** | Medical facility grounding (critical care) |
| **08-AWS** | Data center grounding (sensitive electronics) |
| **17-Flutter** | Mobile grounding calculator app |
| **25-LEO-CLI** | Municipal building grounding |

---

*Last Updated: 2026-02-28*
*The Imperial Ground Rod approved — "Ground It Right, or Light It Up."*
