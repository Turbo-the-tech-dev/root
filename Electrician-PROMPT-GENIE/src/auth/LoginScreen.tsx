/**
 * Imperial Login Screen: Sector 00 Security
 * Vader-approved User Interface for authentication.
 */

import React, { useState } from 'react';
import { useImperialAuth } from './useAuth';

export const LoginScreen: React.FC = () => {
  const { login, status, error } = useImperialAuth();
  const [email, setEmail] = useState('vader@empire.gov');
  const [pass, setPass] = useState('execute-order-66');

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    await login(email, pass);
  };

  return (
    <div className="flex flex-col items-center justify-center min-h-screen bg-black text-white p-6">
      <div className="w-full max-w-md p-8 border-2 border-red-600 rounded-xl shadow-2xl bg-gray-900">
        <div className="text-center mb-8">
          <div className="inline-block p-4 bg-red-600 rounded-full mb-4 shadow-lg animate-pulse">
            <span className="text-4xl">🌑</span>
          </div>
          <h1 className="text-3xl font-black tracking-widest text-red-500 uppercase">IMPERIAL FLEET</h1>
          <p className="text-gray-400 mt-2 font-mono">AUTHORIZED PERSONNEL ONLY</p>
        </div>

        <form onSubmit={handleSubmit} className="space-y-6">
          <div>
            <label className="block text-sm font-bold text-gray-400 uppercase tracking-tighter mb-2">Imperial ID (Email)</label>
            <input
              type="email"
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              className="w-full px-4 py-3 bg-black border border-gray-700 rounded focus:border-red-500 focus:outline-none transition-colors text-white font-mono"
              placeholder="vader@empire.gov"
              required
            />
          </div>

          <div>
            <label className="block text-sm font-bold text-gray-400 uppercase tracking-tighter mb-2">Security Override (Password)</label>
            <input
              type="password"
              value={pass}
              onChange={(e) => setPass(e.target.value)}
              className="w-full px-4 py-3 bg-black border border-gray-700 rounded focus:border-red-500 focus:outline-none transition-colors text-white font-mono"
              placeholder="••••••••"
              required
            />
          </div>

          {error && (
            <div className="p-4 bg-red-900/50 border border-red-600 rounded text-red-200 text-sm font-mono animate-bounce">
              ⚠️ {error}
            </div>
          )}

          <button
            type="submit"
            disabled={status === 'loading'}
            className={`w-full py-4 rounded font-black uppercase tracking-widest text-lg transition-all transform active:scale-95 ${
              status === 'loading'
                ? 'bg-gray-700 cursor-not-allowed text-gray-500'
                : 'bg-red-600 hover:bg-red-700 text-white shadow-[0_0_15px_rgba(220,38,38,0.5)]'
            }`}
          >
            {status === 'loading' ? 'Establishing Secure Link...' : 'LOG IN TO THE EMPIRE'}
          </button>
        </form>

        <div className="mt-8 pt-6 border-t border-gray-800 text-center">
          <p className="text-xs text-gray-500 font-mono italic">
            "Your credentials will be scrutinized. Any sign of rebellion will result in immediate termination."
          </p>
        </div>
      </div>
      
      <p className="mt-6 text-gray-600 text-[10px] tracking-widest uppercase">
        © 2026 Galactic Empire — Sector 00 Security Command
      </p>
    </div>
  );
};
