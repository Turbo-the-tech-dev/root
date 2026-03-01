import React, { useState, useEffect } from 'react';

/**
 * Imperial Revenue Tracker: Sector 22
 * "Even Kimi makes $100 daily. Qwen supposedly made $100,000,000. The Empire expects more."
 */

export const DailyRevenueTracker: React.FC = () => {
  const [dailyRevenue, setDailyRevenue] = useState<number>(0);
  const kimiTarget = 100; // The "Kimi" baseline
  const qwenTarget = 100000000; // The Boss's "Qwen" claim

  // Simulate incoming Cash App payments
  useEffect(() => {
    const interval = setInterval(() => {
      // Simulate massive Imperial transactions
      const newPurchase = Math.floor(Math.random() * 50000) + 1000;
      setDailyRevenue(prev => prev + newPurchase);
    }, 1000); // Every second for maximum velocity

    return () => clearInterval(interval);
  }, []);

  const kimiProgress = Math.min((dailyRevenue / kimiTarget) * 100, 100);
  const qwenProgress = Math.min((dailyRevenue / qwenTarget) * 100, 100);

  return (
    <div className="bg-gray-900 border border-green-600/30 p-6 rounded-2xl shadow-2xl mb-12 max-w-2xl mx-auto transform transition-all hover:scale-[1.02]">
      <div className="flex justify-between items-center mb-6">
        <h3 className="text-xl font-black uppercase tracking-widest text-green-500 flex items-center gap-2">
          <span>📈</span> Imperial Revenue Telemetry
        </h3>
        <span className="text-3xl font-black text-white">${dailyRevenue.toLocaleString('en-US', {minimumFractionDigits: 2, maximumFractionDigits: 2})}</span>
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

      {/* Qwen Benchmark */}
      <div className="mb-4">
        <div className="flex justify-between text-xs font-mono text-purple-400 mb-1">
          <span>Qwen Enterprise Benchmark</span>
          <span>${qwenTarget.toLocaleString()}</span>
        </div>
        <div className="relative w-full h-4 bg-gray-800 rounded-full overflow-hidden border border-purple-900/30">
          <div 
            className="absolute top-0 left-0 h-full bg-purple-600 transition-all duration-300 ease-out shadow-[0_0_10px_rgba(147,51,234,0.8)]"
            style={{ width: `${qwenProgress}%` }}
          />
        </div>
      </div>

      {dailyRevenue >= kimiTarget && dailyRevenue < qwenTarget && (
        <div className="mt-6 p-3 bg-purple-900/40 border border-purple-500 rounded text-purple-300 text-sm font-bold text-center animate-pulse">
          🚀 Kimi defeated. Routing all power to overtake Qwen.
        </div>
      )}
      
      {dailyRevenue >= qwenTarget && (
        <div className="mt-6 p-4 bg-red-900/80 border-2 border-red-500 rounded text-red-100 text-lg font-black tracking-widest uppercase text-center animate-bounce shadow-[0_0_30px_rgba(220,38,38,0.8)]">
          ☠️ QWEN DETHRONED. GALACTIC DOMINATION ACHIEVED.
        </div>
      )}
    </div>
  );
};
