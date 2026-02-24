import React from 'react';
import { PromptTemplate, Framework } from './types';

/**
 * Curated prompt templates surfaced in the "Popular" section of the library.
 * Each entry targets a common electrician workflow: NEC compliance audits,
 * fault diagnosis, and load/service calculations.
 *
 * Sorted by community star count (descending) in the UI.
 */
export const POPULAR_TEMPLATES: PromptTemplate[] = [
  {
    id: '1',
    title: 'NEC Compliance Auditor',
    description: 'Analyzes circuit plans against the latest National Electrical Code standards.',
    // Prompt instructs the AI to act as a Master Electrician reviewing plans
    // against NFPA 70 requirements.
    content: 'Act as a Master Electrician and NEC inspector. Review the following load calculations and wiring plans for compliance with NFPA 70...',
    category: 'Code Compliance',
    author: 'VoltMaster',
    stars: 2100
  },
  {
    id: '2',
    title: 'Fault Finder / Troubleshooter',
    description: 'Step-by-step diagnostic tree for residential and industrial electrical faults.',
    // Prompt accepts a symptom placeholder and produces a safety-first
    // diagnostic sequence for 120V residential split-phase systems.
    content: 'I have a [symptom, e.g., tripping GFCI]. Based on a standard 120V residential split-phase system, provide a safety-first diagnostic sequence...',
    category: 'Troubleshooting',
    author: 'SparkyPro',
    stars: 1540
  },
  {
    id: '3',
    title: 'Load Calculator Pro',
    description: 'Calculates service entrance requirements and branch circuit sizing.',
    // Uses Article 220 demand-load methods. {square_footage} and {appliances}
    // are user-filled placeholders substituted before the prompt is sent.
    content: 'Calculate the total demand load for a {square_footage} sq ft dwelling with the following appliances: {appliances}. Use Article 220 methods...',
    category: 'Estimation',
    author: 'CurrentGen',
    stars: 980
  }
];

/**
 * Reasoning frameworks that adjust the AI's response style and structure.
 * A selected framework is prepended to the prompt as a system instruction,
 * shaping how the model approaches safety, schematic analysis, or mentorship.
 */
export const COGNITIVE_FRAMEWORKS: Framework[] = [
  {
    id: 'safety-first',
    name: 'Safety-First Protocol',
    description: 'Prioritizes OSHA standards and lockout/tagout (LOTO) procedures in every response.',
    // Four-step structure: hazard ID → PPE → de-energization → execution
    structure: '1. Identify Hazards\n2. PPE Requirements\n3. De-energization Steps\n4. Technical Execution.'
  },
  {
    id: 'schematic-logic',
    name: 'Schematic Reasoning',
    description: 'Breaks down complex circuitry from the power source to the load.',
    // Traces the electrical path in the order current flows through a circuit
    structure: 'Source -> Overcurrent Protection -> Conductors -> Controls -> Load.'
  },
  {
    id: 'persona',
    name: 'Journeyman Mentor',
    description: 'Explains complex electrical theory in practical, field-ready terms.',
    // Adopts a veteran tradesperson persona to make technical answers
    // immediately actionable on the job site.
    structure: 'You are a Senior Journeyman with 30 years in the trade. Explain this as if we are on a job site.'
  }
];

/**
 * App icon for the Electrician Prompt Genie.
 *
 * Wrapped with React.memo because this component accepts no props and its
 * output never changes — memoization guarantees the icon is only rendered
 * once regardless of how often the parent re-renders.
 */
export const ElectricianGenieIcon = React.memo(() => (
  <div className="relative w-12 h-12 flex items-center justify-center bg-yellow-500 rounded-xl shadow-lg">
    {/* Primary icon: lightning bolt representing electrical work */}
    <span className="text-2xl">⚡</span>
    {/* Badge overlay: wrench indicating tools / hands-on trade */}
    <span className="absolute -top-1 -right-1 text-xs">🛠️</span>
  </div>
));
