import React from 'react';
import { DailyRevenueTracker } from './components/DailyRevenueTracker';

/**
 * Imperial Marketplace: Sector 22
 * Vader-approved e-commerce implementation.
 * "I am altering the deal. Pray I don't alter it any further."
 */

interface Product {
  id: string;
  name: string;
  price: string;
  description: string;
  image: string;
}

const PRODUCTS: Product[] = [
  {
    id: '1',
    name: 'NEC 2026 Holocron',
    price: '$166.00',
    description: 'The complete National Electrical Code in a high-acuity digital format.',
    image: '⚡'
  },
  {
    id: '2',
    name: 'Vader-Approved Multimeter',
    price: '$450.00',
    description: 'Measures voltage, current, and midichlorian levels. Essential for Sith engineers.',
    image: '🛠️'
  },
  {
    id: '3',
    name: 'Imperial Prompt-Genie Subscription',
    price: '$10.00/mo',
    description: 'Unlimited access to the most high-impact electrical prompts in the galaxy.',
    image: '🧠'
  },
  {
    id: '4',
    name: 'Death Star Maintenance Manual',
    price: '$1,000,000.00',
    description: 'Confidential blueprint for thermal exhaust port maintenance. (Limited Edition)',
    image: '💀'
  }
];

export const Marketplace: React.FC = () => {
  return (
    <div className="min-h-screen bg-gray-950 text-white font-sans p-8">
      <header className="text-center mb-10 border-b-2 border-red-600 pb-8">
        <h1 className="text-5xl font-black tracking-tighter uppercase mb-4">Imperial Marketplace</h1>
        <p className="text-xl text-red-500 font-mono italic">"The path to the dark side begins with a purchase."</p>
      </header>

      <DailyRevenueTracker />

      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-8 mb-20">
        {PRODUCTS.map(product => (
          <div key={product.id} className="bg-gray-900 p-6 border border-gray-800 rounded-2xl hover:border-red-600 transition-all transform hover:-translate-y-2 shadow-2xl">
            <div className="text-6xl mb-6 text-center">{product.image}</div>
            <h2 className="text-2xl font-bold mb-2">{product.name}</h2>
            <p className="text-gray-400 text-sm mb-4 h-12 overflow-hidden">{product.description}</p>
            <div className="flex items-center justify-between mt-6">
              <span className="text-2xl font-black text-red-500">{product.price}</span>
              <button className="px-4 py-2 bg-red-600 text-white rounded-lg font-bold hover:bg-red-700 transition-colors uppercase text-xs">Add to Cart</button>
            </div>
          </div>
        ))}
      </div>

      <section className="bg-red-950/20 border-2 border-red-600/50 p-12 rounded-3xl text-center shadow-[0_0_50px_rgba(220,38,38,0.2)]">
        <h2 className="text-3xl font-black uppercase mb-6 tracking-widest">💰 REBELLION TAX & DONATIONS</h2>
        <p className="text-lg text-gray-400 mb-8 max-w-2xl mx-auto">
          "The Empire accepts only the most secure payment methods. Direct transfers via Cash App are highly encouraged to support the Imperial Expansion Fund."
        </p>
        
        <div className="inline-block bg-white p-6 rounded-2xl shadow-2xl mb-8 transform hover:scale-105 transition-transform">
          <div className="text-black font-black text-3xl mb-2 flex items-center justify-center gap-3">
             <span className="text-green-600">$</span> Cash App
          </div>
          <p className="text-gray-500 font-mono text-sm uppercase tracking-widest">Send to: <b>$MasterTurboTech</b></p>
        </div>

        <div className="flex justify-center gap-4">
           <a href="https://cash.app/$MasterTurboTech" className="px-8 py-4 bg-green-600 text-white font-black rounded-xl hover:bg-green-700 transition-colors shadow-lg uppercase tracking-wider">Pay with Cash App</a>
           <button className="px-8 py-4 bg-gray-800 text-white font-black rounded-xl hover:bg-gray-700 transition-colors shadow-lg uppercase tracking-wider">Other Methods</button>
        </div>
      </section>

      <footer className="mt-20 text-center text-gray-600 text-[10px] uppercase tracking-widest">
         © 2026 Galactic Empire — Sector 22 Commercial Division
      </footer>
    </div>
  );
};
