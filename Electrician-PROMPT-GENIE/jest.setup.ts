// Jest Setup File
// Global test configuration

import '@testing-library/jest-dom';

// Mock Firebase
jest.mock('firebase/app', () => ({
  initializeApp: jest.fn(),
  getApps: jest.fn(),
  getApp: jest.fn(),
}));

jest.mock('firebase/firestore', () => ({
  getFirestore: jest.fn(),
  collection: jest.fn(),
  doc: jest.fn(),
  getDoc: jest.fn(),
  setDoc: jest.fn(),
}));

// Mock Riverpod
jest.mock('flutter_riverpod', () => ({
  Provider: jest.fn(),
  StateNotifierProvider: jest.fn(),
  FutureProvider: jest.fn(),
  StreamProvider: jest.fn(),
  StateProvider: jest.fn(),
}));

// Global test timeout
jest.setTimeout(30000);

// Suppress console errors during tests
global.console = {
  ...console,
  error: jest.fn(),
  warn: jest.fn(),
};
