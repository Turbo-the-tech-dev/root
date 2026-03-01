import React, { useState, useEffect } from 'react';

/**
 * Imperial Revenue Tracker: Sector 22
 * "Even Kimi makes $100 daily. The Empire expects more."
 */

export const DailyRevenueTracker: React.FC = () => {
  const [dailyRevenue, setDailyRevenue] = useState<number>(0);
  const targetGoal = 100; // The "Kimi" baseline

  // Simulate incoming Cash App payments
  useEffect(() => {
    const interval = setInterval(() => {
      // Simulate a random purchase between $5 and $25
      const newPurchase = Math.floor(Math.random() * 20) + 5;
      setDailyRevenue(prev => prev + newPurchase);
    }, 5000); // Every 5 seconds for dramatic effect

    return () => clearInterval(interval);
  }, []);

  const progressPercentage = Math.min((dailyRevenue / targetGoal) * 100, 100);

  return (
    <div className="bg-gray-900 border border-green-600/30 p-6 rounded-2xl shadow-2xl mb-12 max-w-2xl mx-auto transform transition-all hover:scale-[1.02]">
      <div className="flex justify-between items-center mb-4">
        <h3 className="text-xl font-black uppercase tracking-widest text-green-500 flex items-center gap-2">
          <span>📈</span> Daily Imperial Revenue
        </h3>
        <span className="text-3xl font-black text-white">${dailyRevenue.toFixed(2)}</span>
      </div>

      <div className="relative w-full h-4 bg-gray-800 rounded-full overflow-hidden mb-2">
        <div 
          className="absolute top-0 left-0 h-full bg-green-500 transition-all duration-500 ease-out"
          style={{ width: `${progressPercentage}%` }}
        />
      </div>

      <div className="flex justify-between text-xs font-mono text-gray-500">
        <span>$0.00</span>
        <span>"Kimi Baseline" Goal: ${targetGoal.toFixed(2)}</span>
      </div>

      {dailyRevenue >= targetGoal && (
        <div className="mt-4 p-3 bg-green-900/40 border border-green-500 rounded text-green-300 text-sm font-bold text-center animate-pulse">
          ✅ Kimi Baseline Exceeded. The Emperor is pleased.
        </div>
      )}
      
      {dailyRevenue < targetGoal && (
        <div className="mt-4 text-center text-xs text-red-400 font-mono italic">
          "Currently trailing the Kimi Baseline. Increase output immediately."
        </div>
      )}
    </div>
  );
};
