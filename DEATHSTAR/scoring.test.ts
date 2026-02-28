import { test } from 'node:test';
import assert from 'node:assert';
import { calculateScore } from './scoring';

test('calculateScore - empty transcription returns 0', () => {
  assert.strictEqual(calculateScore('', ['keyword']), 0);
});

test('calculateScore - empty keywords returns 0', () => {
  assert.strictEqual(calculateScore('some text', []), 0);
});

test('calculateScore - all keywords found', () => {
  const transcription = 'The quick brown fox jumps over the lazy dog';
  const keywords = ['quick', 'fox', 'lazy'];
  assert.strictEqual(calculateScore(transcription, keywords), 100);
});

test('calculateScore - partial keywords found', () => {
  const transcription = 'The quick brown fox jumps over the lazy dog';
  const keywords = ['quick', 'fox', 'cat'];
  assert.strictEqual(calculateScore(transcription, keywords), (2/3) * 100);
});

test('calculateScore - no keywords found', () => {
  const transcription = 'The quick brown fox jumps over the lazy dog';
  const keywords = ['cat', 'bird'];
  assert.strictEqual(calculateScore(transcription, keywords), 0);
});

test('calculateScore - case insensitivity', () => {
  const transcription = 'THE QUICK BROWN FOX';
  const keywords = ['quick', 'FOX'];
  assert.strictEqual(calculateScore(transcription, keywords), 100);
});

test('calculateScore - duplicate keywords should not skew score', () => {
  const transcription = 'The quick brown fox';
  const keywords = ['quick', 'quick', 'fox'];
  assert.strictEqual(calculateScore(transcription, keywords), 100);
});
