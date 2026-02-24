# ⛓️ NEC Analysis Prompt Chains

## 4-Step Compliance Chain

### Prompt 1: Extract Relevant Sections
```
From the provided NEC query: [paste query]
Extract ONLY exact relevant articles/sections.
Output as numbered list with verbatim text.
```

### Prompt 2: Interpret & Simplify
```
Using ONLY extracted sections above:
Explain in clear step-by-step terms for field electricians.
Use simple language. No jargon without definition.
```

### Prompt 3: Validate Compliance
```
Review interpretation against high-stakes safety risks.
Flag violations, ambiguities, cross-references.
Rate confidence: High/Med/Low
```

### Prompt 4: Structured Output
```
Synthesize into 5W1H+ format:
WHAT, WHY, WHO, WHERE, WHEN, HOW, HOW WELL
```

## HRG Design Chain

1. Estimate charging current (kVA table)
2. Select resistor tap (I_G ≥ 3I_co)
3. Verify NEC 250.36 compliance
4. Output: 5W1H+ + quick reference card
