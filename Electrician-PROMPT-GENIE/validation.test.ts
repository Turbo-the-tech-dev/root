import { describe, it, beforeEach, afterEach } from 'node:test';
import assert from 'node:assert/strict';
import { isQuestion, isQuestionArray, parseQuestionsFromStorage } from './validation';

// ---------------------------------------------------------------------------
// Minimal localStorage shim (Node has none)
// ---------------------------------------------------------------------------
const store: Record<string, string> = {};

const localStorageMock = {
  getItem: (key: string) => (key in store ? store[key] : null),
  setItem: (key: string, value: string) => { store[key] = value; },
  removeItem: (key: string) => { delete store[key]; },
  clear: () => { Object.keys(store).forEach(k => delete store[k]); },
};

// Attach to global so validation.ts can reach it
(globalThis as Record<string, unknown>).localStorage = localStorageMock;

// ---------------------------------------------------------------------------
// isQuestion
// ---------------------------------------------------------------------------

describe('isQuestion', () => {
  it('accepts a valid minimal Question', () => {
    assert.ok(isQuestion({
      id: 'q1',
      text: 'What is the maximum ampacity of 12 AWG copper?',
      options: ['15 A', '20 A', '25 A', '30 A'],
      correctAnswer: 1,
    }));
  });

  it('accepts a valid Question with optional fields', () => {
    assert.ok(isQuestion({
      id: 'q2',
      text: 'What NEC article covers conduit fill?',
      options: ['Article 300', 'Article 310', 'Chapter 9', 'Article 358'],
      correctAnswer: 2,
      necReference: 'NEC Chapter 9, Table 1',
      category: 'Conduit Fill',
    }));
  });

  it('rejects null', () => {
    assert.strictEqual(isQuestion(null), false);
  });

  it('rejects a plain string', () => {
    assert.strictEqual(isQuestion('not an object'), false);
  });

  it('rejects an object with missing id', () => {
    assert.strictEqual(isQuestion({
      text: 'Some question',
      options: ['A', 'B'],
      correctAnswer: 0,
    }), false);
  });

  it('rejects an object with empty id', () => {
    assert.strictEqual(isQuestion({
      id: '',
      text: 'Some question',
      options: ['A', 'B'],
      correctAnswer: 0,
    }), false);
  });

  it('rejects an object with missing text', () => {
    assert.strictEqual(isQuestion({
      id: 'q1',
      options: ['A', 'B'],
      correctAnswer: 0,
    }), false);
  });

  it('rejects options that is not an array', () => {
    assert.strictEqual(isQuestion({
      id: 'q1',
      text: 'Question?',
      options: 'not-an-array',
      correctAnswer: 0,
    }), false);
  });

  it('rejects options with fewer than two entries', () => {
    assert.strictEqual(isQuestion({
      id: 'q1',
      text: 'Question?',
      options: ['Only one'],
      correctAnswer: 0,
    }), false);
  });

  it('rejects options containing a non-string element', () => {
    assert.strictEqual(isQuestion({
      id: 'q1',
      text: 'Question?',
      options: ['A', 42],
      correctAnswer: 0,
    }), false);
  });

  it('rejects a non-integer correctAnswer', () => {
    assert.strictEqual(isQuestion({
      id: 'q1',
      text: 'Question?',
      options: ['A', 'B'],
      correctAnswer: 0.5,
    }), false);
  });

  it('rejects a correctAnswer that is out of bounds', () => {
    assert.strictEqual(isQuestion({
      id: 'q1',
      text: 'Question?',
      options: ['A', 'B'],
      correctAnswer: 5,
    }), false);
  });

  it('rejects a negative correctAnswer', () => {
    assert.strictEqual(isQuestion({
      id: 'q1',
      text: 'Question?',
      options: ['A', 'B'],
      correctAnswer: -1,
    }), false);
  });

  it('rejects necReference that is not a string', () => {
    assert.strictEqual(isQuestion({
      id: 'q1',
      text: 'Question?',
      options: ['A', 'B'],
      correctAnswer: 0,
      necReference: 99,
    }), false);
  });

  it('rejects category that is not a string', () => {
    assert.strictEqual(isQuestion({
      id: 'q1',
      text: 'Question?',
      options: ['A', 'B'],
      correctAnswer: 0,
      category: true,
    }), false);
  });
});

// ---------------------------------------------------------------------------
// isQuestionArray
// ---------------------------------------------------------------------------

describe('isQuestionArray', () => {
  it('accepts an empty array', () => {
    assert.ok(isQuestionArray([]));
  });

  it('accepts an array of valid Questions', () => {
    assert.ok(isQuestionArray([
      { id: 'q1', text: 'Q1?', options: ['A', 'B'], correctAnswer: 0 },
      { id: 'q2', text: 'Q2?', options: ['X', 'Y', 'Z'], correctAnswer: 2 },
    ]));
  });

  it('rejects a non-array value', () => {
    assert.strictEqual(isQuestionArray({ id: 'q1' }), false);
  });

  it('rejects an array where one element is invalid', () => {
    assert.strictEqual(isQuestionArray([
      { id: 'q1', text: 'Q1?', options: ['A', 'B'], correctAnswer: 0 },
      { id: 'bad', text: 'Missing options' }, // invalid
    ]), false);
  });
});

// ---------------------------------------------------------------------------
// parseQuestionsFromStorage
// ---------------------------------------------------------------------------

describe('parseQuestionsFromStorage', () => {
  beforeEach(() => localStorageMock.clear());
  afterEach(() => localStorageMock.clear());

  it('returns [] when the key does not exist', () => {
    assert.deepStrictEqual(parseQuestionsFromStorage('missing-key'), []);
  });

  it('returns [] when the stored value is invalid JSON', () => {
    localStorageMock.setItem('quiz', '{broken json');
    assert.deepStrictEqual(parseQuestionsFromStorage('quiz'), []);
  });

  it('returns [] when the stored JSON is not a Question[]', () => {
    localStorageMock.setItem('quiz', JSON.stringify({ notAnArray: true }));
    assert.deepStrictEqual(parseQuestionsFromStorage('quiz'), []);
  });

  it('returns [] when the stored array contains a malformed Question', () => {
    const malformed = [{ id: 'q1', text: 'Q?' }]; // missing options / correctAnswer
    localStorageMock.setItem('quiz', JSON.stringify(malformed));
    assert.deepStrictEqual(parseQuestionsFromStorage('quiz'), []);
  });

  it('returns the parsed array for valid Question[] data', () => {
    const questions = [
      { id: 'q1', text: 'Q1?', options: ['A', 'B'], correctAnswer: 1 },
    ];
    localStorageMock.setItem('quiz', JSON.stringify(questions));
    assert.deepStrictEqual(parseQuestionsFromStorage('quiz'), questions);
  });

  it('preserves optional fields when they are present and valid', () => {
    const questions = [
      {
        id: 'q1',
        text: 'Q1?',
        options: ['A', 'B'],
        correctAnswer: 0,
        necReference: 'NEC 310.15',
        category: 'Ampacity',
      },
    ];
    localStorageMock.setItem('quiz', JSON.stringify(questions));
    assert.deepStrictEqual(parseQuestionsFromStorage('quiz'), questions);
  });
});
