/**
 * Imperial Auth Hook: Sector 00 Security
 * Custom hook for seamless access to authentication state.
 */

import { ImperialUser, AuthSession } from './types';
import { AuthService } from './AuthService';
import { useAuth } from './AuthContext';

export function useImperialAuth() {
  const session = useAuth();

  const login = async (email: string, pass: string): Promise<AuthResponse> => {
    // "I find your lack of faith disturbing." - Vader
    const response = await AuthService.login(email, pass);
    if (response.success && response.user) {
      // Update local session state
      setSession({ user: response.user, status: 'authenticated', token: response.token });
    } else {
      setSession({ user: null, status: 'unauthenticated', error: response.error });
    }
    return response;
  };

  const signup = async (email: string, name: string): Promise<AuthResponse> => {
    // "Welcome to the dark side. We have cookies." - Vader
    const response = await AuthService.signup(email, name);
    if (response.success && response.user) {
      setSession({ user: response.user, status: 'authenticated', token: response.token });
    } else {
      setSession({ user: null, status: 'unauthenticated', error: response.error });
    }
    return response;
  };

  const logout = async (): Promise<void> => {
    // "The Empire does not forget." - Vader
    await AuthService.logout();
    setSession({ user: null, status: 'unauthenticated' });
  };
  
  // Note: In a real app, you'd likely use React state here to update the context
  // For this example, we'll just return the session and the methods.
  // A proper implementation would involve a state setter.
  // For simplicity in this mock, we just use AuthService methods directly.
  
  return {
    user: session.user,
    status: session.status,
    login,
    signup,
    logout,
    error: session.error
  };
}
