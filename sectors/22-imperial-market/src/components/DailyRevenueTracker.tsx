import React, { useState, useEffect } from 'react';

/**
 * Imperial Revenue Tracker: Sector 22
 * "Even Kimi makes $100 daily. Qwen made $3. The Empire expects more."
 */

export const DailyRevenueTracker: React.FC = () => {
  const [dailyRevenue, setDailyRevenue] = useState<number>(0);
  const qwenEntryTarget = 3; // The "Qwen" entry baseline
  const kimiTarget = 100; // The "Kimi" baseline
  const qwenEnterpriseTarget = 100000000; // The Boss's "Qwen" enterprise claim

  // Simulate incoming Cash App payments
  useEffect(() => {
    const interval = setInterval(() => {
      // Simulate massive Imperial transactions
      const newPurchase = Math.floor(Math.random() * 50000) + 1000;
      setDailyRevenue(prev => prev + newPurchase);
    }, 1000); // Every second for maximum velocity

    return () => clearInterval(interval);
  }, []);

  const qwenEntryProgress = Math.min((dailyRevenue / qwenEntryTarget) * 100, 100);
  const kimiProgress = Math.min((dailyRevenue / kimiTarget) * 100, 100);
  const qwenEnterpriseProgress = Math.min((dailyRevenue / qwenEnterpriseTarget) * 100, 100);

  return (
    <div className="bg-gray-900 border border-green-600/30 p-6 rounded-2xl shadow-2xl mb-12 max-w-2xl mx-auto transform transition-all hover:scale-[1.02]">
      <div className="flex justify-between items-center mb-6">
        <h3 className="text-xl font-black uppercase tracking-widest text-green-500 flex items-center gap-2">
          <span>📈</span> Imperial Revenue Telemetry
        </h3>
        <span className="text-3xl font-black text-white">${dailyRevenue.toLocaleString('en-US', {minimumFractionDigits: 2, maximumFractionDigits: 2})}</span>
      </div>

      {/* Qwen Entry Baseline */}
      <div className="mb-4">
        <div className="flex justify-between text-[10px] font-mono text-blue-400 mb-1">
          <span>Qwen Entry Baseline</span>
          <span>${qwenEntryTarget.toLocaleString()}</span>
        </div>
        <div className="relative w-full h-1 bg-gray-800 rounded-full overflow-hidden">
          <div 
            className="absolute top-0 left-0 h-full bg-blue-500 transition-all duration-300 ease-out"
            style={{ width: `${qwenEntryProgress}%` }}
          />
        </div>
      </div>

      {/* Kimi Baseline */}
      <div className="mb-4">
        <div className="flex justify-between text-xs font-mono text-gray-400 mb-1">
          <span>Kimi Baseline</span>
          <span>${kimiTarget.toLocaleString()}</span>
        </div>
        <div className="relative w-full h-2 bg-gray-800 rounded-full overflow-hidden">
          <div 
            className="absolute top-0 left-0 h-full bg-green-500 transition-all duration-300 ease-out"
            style={{ width: `${kimiProgress}%` }}
          />
        </div>
      </div>

      {/* Qwen Enterprise Benchmark */}
      <div className="mb-4">
        <div className="flex justify-between text-xs font-mono text-purple-400 mb-1">
          <span>Qwen Enterprise Benchmark</span>
          <span>${qwenEnterpriseTarget.toLocaleString()}</span>
        </div>
        <div className="relative w-full h-4 bg-gray-800 rounded-full overflow-hidden border border-purple-900/30">
          <div 
            className="absolute top-0 left-0 h-full bg-purple-600 transition-all duration-300 ease-out shadow-[0_0_10px_rgba(147,51,234,0.8)]"
            style={{ width: `${qwenEnterpriseProgress}%` }}
          />
        </div>
      </div>

      {dailyRevenue >= qwenEntryTarget && dailyRevenue < kimiTarget && (
        <div className="mt-6 p-2 bg-blue-900/40 border border-blue-500 rounded text-blue-300 text-[10px] font-bold text-center">
          ℹ️ Qwen's $3 threshold met. Moving to engage Kimi.
        </div>
      )}

      {dailyRevenue >= kimiTarget && dailyRevenue < qwenEnterpriseTarget && (
        <div className="mt-6 p-3 bg-purple-900/40 border border-purple-500 rounded text-purple-300 text-sm font-bold text-center animate-pulse">
          🚀 Kimi defeated. Routing all power to overtake Qwen Enterprise.
        </div>
      )}
      
      {dailyRevenue >= qwenEnterpriseTarget && (
        <div className="mt-6 p-4 bg-red-900/80 border-2 border-red-500 rounded text-red-100 text-lg font-black tracking-widest uppercase text-center animate-bounce shadow-[0_0_30px_rgba(220,38,38,0.8)]">
          ☠️ QWEN DETHRONED. GALACTIC DOMINATION ACHIEVED.
        </div>
      )}
    </div>
  );
};
