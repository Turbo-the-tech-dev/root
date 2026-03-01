/**
 * Imperial Auth Service Tests: Sector 00 Security
 * Vader-approved Unit Tests.
 */

import { describe, it, expect, beforeEach } from '@jest/globals';
import { AuthService } from './AuthService';

describe('ImperialAuthService', () => {
  beforeEach(() => {
    // Reset internal state for each test if necessary
    // AuthService is a singleton, so we may need a reset method for testing
  });

  it('should authenticate a high-ranking official correctly', async () => {
    const response = await AuthService.login('vader@empire.gov', 'execute-order-66');
    expect(response.success).toBe(true);
    expect(response.user?.name).toBe('Anakin Skywalker');
    expect(response.user?.role).toBe('Vader');
    expect(response.token).toBeDefined();
  });

  it('should deny a rebel spy with invalid credentials', async () => {
    const response = await AuthService.login('rebel@spy.org', 'wrong-pass');
    expect(response.success).toBe(false);
    expect(response.error).toContain('Insignificant rebellion detected');
  });

  it('should sign up a new recruit as a stormtrooper', async () => {
    const response = await AuthService.signup('new@recruit.gov', 'TK-421');
    expect(response.success).toBe(true);
    expect(response.user?.role).toBe('Stormtrooper');
    expect(response.user?.rank).toMatch(/^TK-\d+$/);
  });

  it('should log out and clear the session', async () => {
    await AuthService.login('vader@empire.gov', 'execute-order-66');
    expect(AuthService.getCurrentUser()).not.toBeNull();
    
    await AuthService.logout();
    expect(AuthService.getCurrentUser()).toBeNull();
  });
});
