/**
 * Imperial Auth Types: Sector 00 Security
 * Vader-approved user and session definitions.
 */

export type UserRole = 'Vader' | 'Admiral' | 'Stormtrooper' | 'Droid';

export interface ImperialUser {
  id: string;
  email: string;
  name: string;
  role: UserRole;
  rank: string;
  accessLevel: number;
  lastLogin: Date;
}

export interface AuthSession {
  user: ImperialUser | null;
  status: 'authenticated' | 'unauthenticated' | 'loading' | 'rebellion-detected';
  token?: string;
  error?: string;
}

export interface AuthResponse {
  success: boolean;
  user?: ImperialUser;
  token?: string;
  error?: string;
}
