/**
 * Represents an AI prompt template for electrician-specific tasks.
 * Templates are displayed in the prompt library and can be copied or
 * used directly as starting points for AI conversations.
 */
export interface PromptTemplate {
  /** Unique identifier for the template */
  id: string;
  /** Short display name shown in the library UI */
  title: string;
  /** One-sentence summary of what the template does */
  description: string;
  /** The full prompt text sent to the AI model */
  content: string;
  /** Grouping label (e.g. "Code Compliance", "Troubleshooting") */
  category: string;
  /** Display name of the template's creator */
  author: string;
  /** Community star/upvote count used for sorting */
  stars: number;
}

/**
 * Defines a structured reasoning approach that guides how the AI
 * frames and formats its responses (e.g. safety-first, schematic logic).
 */
export interface Framework {
  /** Unique identifier for the framework */
  id: string;
  /** Human-readable framework name shown in the UI */
  name: string;
  /** Explains the reasoning strategy behind this framework */
  description: string;
  /**
   * The system-level instruction injected into the prompt to activate
   * this framework's reasoning style.
   */
  structure: string;
}
