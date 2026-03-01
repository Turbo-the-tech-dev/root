/**
 * Imperial Auth Guard: Sector 00 Security
 * Vader-approved Route Protector. 
 * "I find your lack of faith disturbing."
 */

import React from 'react';
import { useAuth } from './AuthContext';

interface AuthGuardProps {
  children: React.ReactNode;
  fallback?: React.ReactNode;
  requiredRole?: string;
}

export const AuthGuard: React.FC<AuthGuardProps> = ({ children, fallback, requiredRole }) => {
  const { user, status } = useAuth();

  if (status === 'loading') {
    return (
      <div className="flex items-center justify-center min-h-screen bg-gray-900 text-white">
        <p className="text-xl">🚀 Establishing Secure Holonet Connection...</p>
      </div>
    );
  }

  if (!user || status !== 'authenticated') {
    return (
      <div className="flex items-center justify-center min-h-screen bg-black text-red-500">
        <div className="text-center p-8 border-2 border-red-500 rounded-lg shadow-2xl">
          <h1 className="text-4xl font-bold mb-4">🚫 ACCESS DENIED</h1>
          <p className="text-xl mb-4">The Rebellion has been detected. Your credentials are insufficient.</p>
          <p className="text-lg">Please report to the nearest Imperial recruitment station.</p>
          {fallback || <button className="mt-8 px-6 py-3 bg-red-600 text-white rounded hover:bg-red-700 transition-colors">LOGIN TO THE EMPIRE</button>}
        </div>
      </div>
    );
  }

  // Check role-based access control (RBAC)
  if (requiredRole && user.role !== requiredRole && user.role !== 'Vader') {
    return (
      <div className="flex items-center justify-center min-h-screen bg-black text-yellow-500">
        <div className="text-center p-8 border-2 border-yellow-500 rounded-lg shadow-2xl">
          <h1 className="text-4xl font-bold mb-4">⚠️ INSUFFICIENT RANK</h1>
          <p className="text-xl mb-4">Your current rank of {user.rank} is insufficient to access this Sector.</p>
          <p className="text-lg">Only those with the rank of {requiredRole} or higher may enter.</p>
          <p className="text-md mt-4 text-gray-400">"Lord Vader will see to it that your failure is rewarded appropriately."</p>
        </div>
      </div>
    );
  }

  // Access granted
  return <>{children}</>;
};
