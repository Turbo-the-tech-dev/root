import { Question } from './types';

/**
 * Type guard that checks whether an unknown value conforms to the
 * `Question` interface at runtime.  Every field required by the interface
 * is validated here so that callers can trust the shape after the guard.
 */
export function isQuestion(value: unknown): value is Question {
  if (typeof value !== 'object' || value === null) return false;

  const q = value as Record<string, unknown>;

  if (typeof q.id !== 'string' || q.id === '') return false;
  if (typeof q.text !== 'string' || q.text === '') return false;
  if (!Array.isArray(q.options) || q.options.length < 2) return false;
  if (!q.options.every((o: unknown) => typeof o === 'string')) return false;
  if (typeof q.correctAnswer !== 'number') return false;
  if (!Number.isInteger(q.correctAnswer)) return false;
  if (q.correctAnswer < 0 || q.correctAnswer >= q.options.length) return false;

  // Optional fields — only validate type when present
  if (q.necReference !== undefined && typeof q.necReference !== 'string') return false;
  if (q.category !== undefined && typeof q.category !== 'string') return false;

  return true;
}

/**
 * Type guard that narrows an unknown value to `Question[]`.
 * Returns false if the value is not an array or any element fails `isQuestion`.
 */
export function isQuestionArray(value: unknown): value is Question[] {
  return Array.isArray(value) && value.every(isQuestion);
}

/**
 * Safely reads a `Question[]` from `localStorage` under the given key.
 *
 * Replaces the unsafe `JSON.parse(...) as Question[]` pattern with:
 *  1. A try-catch that swallows parse errors and missing-key cases
 *  2. A runtime type guard that rejects any malformed data
 *
 * @param key - The localStorage key to read from
 * @returns The validated array, or an empty array if anything goes wrong
 */
export function parseQuestionsFromStorage(key: string): Question[] {
  try {
    const raw = localStorage.getItem(key);
    if (raw === null) return [];

    const parsed: unknown = JSON.parse(raw);
    if (!isQuestionArray(parsed)) {
      console.warn(
        `[validation] localStorage["${key}"] did not match Question[]. Falling back to [].`
      );
      return [];
    }

    return parsed;
  } catch (err) {
    console.error(`[validation] Failed to parse localStorage["${key}"]:`, err);
    return [];
  }
}
