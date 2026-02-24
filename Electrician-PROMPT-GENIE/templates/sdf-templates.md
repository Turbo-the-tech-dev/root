# 🎯 SDF v1.0 Prompt Templates

## Gate Templates

### Twin Gate A: Intent-Audience Check
```
Before proceeding, verify:
1. WHY: Is a clear, high-stakes objective stated? (Cost of error > medium)
2. WHO: Is request from/aligned with Systems Architect role?

If either fails: HALT → "Scope Violation: [specific]"
```

### Gate G1: Why Defined
```
Required: Measurable outcome
Format: "Reduce [X] by [Y]%" or "Prevent [X] from occurring"
Fail: "State the objective"
```

### Gate G3: Scope Violation Alert
```
⚠️ SCOPE VIOLATION DETECTED

Requested: [X]
Status: Out-of-Scope for SDF v1.0
Reason: [Creative Prose | External Integration | Multi-Agent | UI Design]

Redirect: Reframe as structural/analytical request.
```

## ToT Prompt Template
```
Apply Tree of Thoughts v1 under SDF governance.
Problem: [NEC query]
Step 1: Decompose into 3-5 thoughts
Step 2: Evaluate each (compliance, safety, practicality)
Step 3: Expand top 2 branches
Step 4: Select best path → 5W1H+ format
Enforce Twin Gate before each expansion.
```

## 5W1H+ Output Template
```markdown
**WHAT** — [Rule/deliverable]
**WHY** — [Purpose/safety]
**WHO** — [Stakeholders]
**WHERE** — [Context/location]
**WHEN** — [Timeline/conditions]
**HOW** — [Steps/implementation]
**HOW WELL** — [Risks/confidence]
```
