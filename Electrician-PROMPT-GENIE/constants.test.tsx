import { describe, it } from 'node:test';
import assert from 'node:assert';
import React from 'react';
import { renderToStaticMarkup } from 'react-dom/server';
import { ElectricianGenieIcon, POPULAR_TEMPLATES, COGNITIVE_FRAMEWORKS } from './constants';

// ---------------------------------------------------------------------------
// Data export tests
// Verify that the constant arrays exist, have the expected length, and are
// exported correctly so consumers can rely on them at runtime.
// ---------------------------------------------------------------------------

describe('Constants', () => {
  it('should export POPULAR_TEMPLATES', () => {
    // Confirm the export is an array (not undefined or a non-array value)
    assert.ok(Array.isArray(POPULAR_TEMPLATES));
    // Exactly 3 templates should be present — update this count if new
    // templates are added to the library.
    assert.strictEqual(POPULAR_TEMPLATES.length, 3);
  });

  it('should export COGNITIVE_FRAMEWORKS', () => {
    // Same shape check as POPULAR_TEMPLATES
    assert.ok(Array.isArray(COGNITIVE_FRAMEWORKS));
    // Exactly 3 frameworks should be present
    assert.strictEqual(COGNITIVE_FRAMEWORKS.length, 3);
  });
});

// ---------------------------------------------------------------------------
// ElectricianGenieIcon component tests
// Verify rendering output and that React.memo wrapping is applied correctly.
// ---------------------------------------------------------------------------

describe('ElectricianGenieIcon', () => {
  it('should render correctly', () => {
    // Server-render the component to a static HTML string so we can inspect
    // its output without a DOM or browser environment.
    const html = renderToStaticMarkup(<ElectricianGenieIcon />);
    // Both emoji characters must appear in the rendered markup
    assert.ok(html.includes('⚡'));
    assert.ok(html.includes('🛠️'));
  });

  it('should be a memoized component', () => {
    // React.memo returns an object (specifically a React element type with
    // $$typeof === Symbol(react.memo)), not a plain function. This confirms
    // the export was wrapped with React.memo rather than exported as a raw
    // function component.
    assert.strictEqual(typeof ElectricianGenieIcon, 'object');
  });
});
