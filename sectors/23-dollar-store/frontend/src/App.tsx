/**
 * Three Dollar Store: Sector 23
 * "Affiliate Marketing & E-commerce, Imperial Style."
 */

import React, { useState } from 'react';

// --- Types ---
interface Product {
  id: string;
  name: string;
  price: number;
  category: 'Tech' | 'Home' | 'Imperial';
  inventory: number;
  affiliateLink: string;
}

const INVENTORY: Product[] = [
  { id: '1', name: 'Micro-USB Cable (3-pack)', price: 3.00, category: 'Tech', inventory: 500, affiliateLink: '?ref=vader' },
  { id: '2', name: 'LED Night Light', price: 3.00, category: 'Home', inventory: 200, affiliateLink: '?ref=vader' },
  { id: '3', name: 'Stormtrooper Decal', price: 3.00, category: 'Imperial', inventory: 150, affiliateLink: '?ref=vader' },
  { id: '4', name: 'Mini Screwdriver Set', price: 3.00, category: 'Tech', inventory: 75, affiliateLink: '?ref=vader' },
];

// --- Components ---

const ProductCard: React.FC<{ product: Product, onBuy: (p: Product) => void }> = ({ product, onBuy }) => (
  <div className="bg-gray-800 border border-gray-700 p-4 rounded-xl shadow-lg hover:border-green-500 transition-colors">
    <h3 className="text-lg font-bold text-white mb-2">{product.name}</h3>
    <div className="flex justify-between items-center mb-4">
      <span className="text-green-400 font-black text-xl">${product.price.toFixed(2)}</span>
      <span className="text-xs text-gray-400 font-mono">Stock: {product.inventory}</span>
    </div>
    <button 
      onClick={() => onBuy(product)}
      className="w-full py-2 bg-green-600 hover:bg-green-700 text-white font-bold rounded shadow-md uppercase tracking-wider text-sm transition-transform active:scale-95"
    >
      Buy Now (Affiliate)
    </button>
  </div>
);

const ReportingDashboard: React.FC<{ sales: number, orders: number }> = ({ sales, orders }) => {
  const avgOrderValue = orders > 0 ? sales / orders : 0;
  const conversionRate = 3.14; // Simulated static conversion rate for MVP

  return (
    <div className="bg-gray-900 border-t border-gray-800 p-6 mt-8 rounded-t-3xl">
      <h2 className="text-2xl font-black text-white uppercase tracking-widest mb-6 border-b border-gray-800 pb-2">
        📊 Affiliate Reporting
      </h2>
      <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
        <div className="p-4 bg-gray-800 rounded-lg">
          <p className="text-xs text-gray-400 uppercase font-bold">Total Sales</p>
          <p className="text-2xl font-black text-green-400">${sales.toFixed(2)}</p>
        </div>
        <div className="p-4 bg-gray-800 rounded-lg">
          <p className="text-xs text-gray-400 uppercase font-bold">Total Orders</p>
          <p className="text-2xl font-black text-blue-400">{orders}</p>
        </div>
        <div className="p-4 bg-gray-800 rounded-lg">
          <p className="text-xs text-gray-400 uppercase font-bold">Avg Order Value</p>
          <p className="text-2xl font-black text-purple-400">${avgOrderValue.toFixed(2)}</p>
        </div>
        <div className="p-4 bg-gray-800 rounded-lg">
          <p className="text-xs text-gray-400 uppercase font-bold">Conversion Rate</p>
          <p className="text-2xl font-black text-yellow-400">{conversionRate}%</p>
        </div>
      </div>
    </div>
  );
};

export const ThreeDollarStore: React.FC = () => {
  const [totalSales, setTotalSales] = useState(0);
  const [orderCount, setOrderCount] = useState(0);

  const handleBuy = (product: Product) => {
    // Simulate a purchase hitting the backend
    setTotalSales(prev => prev + product.price);
    setOrderCount(prev => prev + 1);
    console.log(`[AFFILIATE TRACKING] Sale registered via ${product.affiliateLink}`);
  };

  return (
    <div className="min-h-screen bg-black font-sans text-gray-200">
      <header className="bg-green-900/20 border-b border-green-600/30 p-6 text-center">
        <h1 className="text-4xl font-black text-white uppercase tracking-tighter">
          <span className="text-green-500">$3</span> Dollar Store
        </h1>
        <p className="text-green-400 text-sm mt-2 font-mono uppercase tracking-widest">
          Premium Quality. Imperial Affiliation. Everything is $3.
        </p>
      </header>

      <main className="p-8 max-w-6xl mx-auto">
        <div className="flex justify-between items-end mb-6">
          <h2 className="text-2xl font-bold text-white">Live Inventory</h2>
          <span className="text-xs font-mono text-gray-500">PostgreSQL Backend Sync: Active</span>
        </div>
        
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
          {INVENTORY.map(product => (
            <ProductCard key={product.id} product={product} onBuy={handleBuy} />
          ))}
        </div>
      </main>

      <ReportingDashboard sales={totalSales} orders={orderCount} />
    </div>
  );
};
