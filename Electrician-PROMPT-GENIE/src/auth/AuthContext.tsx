/**
 * Imperial Auth Context: Sector 00 Security
 * Vader-approved React Context for session management.
 */

import React, { createContext, useContext, useState, useEffect } from 'react';
import { ImperialUser, AuthSession } from './types';
import { AuthService } from './AuthService';

const AuthContext = createContext<AuthSession | undefined>(undefined);

export const AuthProvider: React.FC<{ children: React.ReactNode }> = ({ children }) => {
  const [session, setSession] = useState<AuthSession>({
    user: null,
    status: 'loading'
  });

  useEffect(() => {
    // Check for existing session (e.g., from local storage)
    const storedUser = AuthService.getCurrentUser();
    if (storedUser) {
      setSession({
        user: storedUser,
        status: 'authenticated'
      });
    } else {
      setSession({
        user: null,
        status: 'unauthenticated'
      });
    }
  }, []);

  // Expose the session state to the rest of the app
  return (
    <AuthContext.Provider value={session}>
      {children}
    </AuthContext.Provider>
  );
};

export const useAuth = () => {
  const context = useContext(AuthContext);
  if (context === undefined) {
    throw new Error('useAuth must be used within an AuthProvider. Significant rebellion detected!');
  }
  return context;
};
