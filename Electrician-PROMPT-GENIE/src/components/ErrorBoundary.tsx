import React, { Component, ErrorInfo, ReactNode } from 'react';
import { Logger } from '../utils/logger';

interface Props {
  children: ReactNode;
}

interface State {
  hasError: boolean;
  error?: Error;
}

class ImperialErrorBoundary extends Component<Props, State> {
  public state: State = {
    hasError: false
  };

  public static getDerivedStateFromError(error: Error): State {
    // Update state so the next render will show the fallback UI.
    return { hasError: true, error };
  }

  public componentDidCatch(error: Error, errorInfo: ErrorInfo) {
    Logger.fatal('⚠️ IMPERIAL SYSTEM FAILURE DETECTED', {
      error,
      errorInfo
    });
  }

  public render() {
    if (this.state.hasError) {
      return (
        <div className="flex flex-col items-center justify-center min-h-screen bg-black text-red-500 font-mono p-8">
          <div className="text-6xl mb-4 animate-pulse">💀</div>
          <h1 className="text-4xl font-black uppercase mb-4 tracking-widest border-b-2 border-red-500">CRITICAL SYSTEM ERROR</h1>
          <p className="text-xl mb-4">A rebel glitch has infiltrated the core logic. Admiral Piett has been informed.</p>
          <div className="bg-gray-900 text-red-400 p-4 rounded-lg w-full max-w-2xl overflow-auto border border-red-900/50 shadow-inner">
            <p className="text-xs mb-2 uppercase font-bold text-gray-500 tracking-tighter">Diagnostic Telemetry:</p>
            <p className="text-sm">{this.state.error?.message || 'Unknown sector malfunction'}</p>
            {this.state.error?.stack && (
              <pre className="text-[10px] mt-4 opacity-50 whitespace-pre-wrap leading-tight border-t border-gray-800 pt-4">
                {this.state.error.stack}
              </pre>
            )}
          </div>
          <button
            onClick={() => window.location.reload()}
            className="mt-8 px-8 py-3 bg-red-600 text-white font-bold uppercase tracking-widest hover:bg-red-700 transition-colors shadow-[0_0_20px_rgba(220,38,38,0.5)] active:scale-95"
          >
            RE-INITIALIZE NEURAL CORE
          </button>
        </div>
      );
    }

    return this.children;
  }
}

export default ImperialErrorBoundary;
