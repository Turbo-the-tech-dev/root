import { describe, it } from '@jest/globals';
import assert from 'node:assert';
import React from 'react';
import { renderToStaticMarkup } from 'react-dom/server';
import MyComponent from './MyComponent';

describe('MyComponent', () => {
  it('should render correctly with default props', () => {
    const html = renderToStaticMarkup(<MyComponent />);
    assert.ok(html.includes('Default Title'));
    assert.ok(html.includes('This is MyComponent.'));
  });

  it('should render correctly with a custom title', () => {
    const title = 'Custom Test Title';
    const html = renderToStaticMarkup(<MyComponent title={title} />);
    assert.ok(html.includes(title));
  });
});
