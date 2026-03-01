/**
 * Imperial Auth Service — Vader-approved Security logic.
 * The Empire does not forget, and it certainly does not forgive weak authentication.
 */

import { ImperialUser, AuthResponse } from './types';

// Mock users for the demonstration
const MOCK_USERS: Record<string, ImperialUser> = {
  'vader@empire.gov': {
    id: '0',
    email: 'vader@empire.gov',
    name: 'Anakin Skywalker',
    role: 'Vader',
    rank: 'Dark Lord of the Sith',
    accessLevel: 100,
    lastLogin: new Date()
  },
  'piett@empire.gov': {
    id: '1',
    email: 'piett@empire.gov',
    name: 'Firmus Piett',
    role: 'Admiral',
    rank: 'Admiral of the Imperial Fleet',
    accessLevel: 80,
    lastLogin: new Date()
  }
};

class ImperialAuthService {
  private static instance: ImperialAuthService;
  private currentUser: ImperialUser | null = null;

  private constructor() {}

  public static getInstance(): ImperialAuthService {
    if (!ImperialAuthService.instance) {
      ImperialAuthService.instance = new ImperialAuthService();
    }
    return ImperialAuthService.instance;
  }

  /**
   * Authenticate with the Imperial Database.
   * "I find your lack of faith disturbing."
   */
  public async login(email: string, pass: string): Promise<AuthResponse> {
    console.log(`🚀 [IMPERIAL-AUTH] Attempting login for: ${email}`);
    
    // Simulate network latency (The Holonet is busy)
    await new Promise(resolve => setTimeout(resolve, 800));

    // Simple mock logic - in reality, we'd use Firebase or another secure auth provider
    const user = MOCK_USERS[email];
    if (user && pass === 'execute-order-66') {
      this.currentUser = user;
      console.log(`✅ [IMPERIAL-AUTH] Authentication successful. Welcome, ${user.rank} ${user.name}.`);
      return {
        success: true,
        user: this.currentUser,
        token: 'imp_sess_' + Math.random().toString(36).substr(2)
      };
    }

    console.error(`❌ [IMPERIAL-AUTH] Authentication failed for: ${email}. The Rebellion will pay for this insolence.`);
    return {
      success: false,
      error: 'Insignificant rebellion detected: Invalid credentials.'
    };
  }

  /**
   * Sign up for the Imperial Fleet.
   * "Welcome to the dark side. We have cookies (and cookies for session management)."
   */
  public async signup(email: string, name: string): Promise<AuthResponse> {
    console.log(`🆕 [IMPERIAL-AUTH] New recruit signing up: ${name} (${email})`);
    
    const newUser: ImperialUser = {
      id: Math.random().toString(36).substr(2, 9),
      email,
      name,
      role: 'Stormtrooper',
      rank: 'TK-' + Math.floor(Math.random() * 10000),
      accessLevel: 10,
      lastLogin: new Date()
    };

    this.currentUser = newUser;
    return {
      success: true,
      user: newUser,
      token: 'imp_sess_' + Math.random().toString(36).substr(2)
    };
  }

  /**
   * Logout from the session.
   * "The Empire does not forget."
   */
  public async logout(): Promise<void> {
    console.log('🚪 [IMPERIAL-AUTH] Session terminated. Goodbye.');
    this.currentUser = null;
  }

  /**
   * Get the current user session.
   */
  public getCurrentUser(): ImperialUser | null {
    return this.currentUser;
  }
}

export const AuthService = ImperialAuthService.getInstance();
