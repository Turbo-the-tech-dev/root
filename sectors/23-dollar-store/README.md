# Sector 23 — $3 Dollar Store (Imperial Discount Retail)

> "Everything must go! Even the Empire needs cash flow." — Vader

---

## 🛒 Overview

Live $3 product grid with affiliate marketing integration. Every item costs exactly **$3 DKK** (or equivalent).

**Architecture:**
- **Frontend:** React (web), Flutter (mobile)
- **Backend:** Node.js/Express API
- **Database:** PostgreSQL
- **Deployment:** AWS Amplify
- **Affiliate Tracking:** `?ref=vader` on all purchases

---

## 📦 Features

### 1. Live Inventory Grid

Real-time product listings:
- Micro-USB Cables
- Stormtrooper Decals
- Phone Cases
- Cable Organizers
- LED Lights
- And more!

### 2. Affiliate Marketing

Every "Buy Now" button:
```
https://amazon.com/product?ref=vader&source=sector23
```

Tracking parameters:
- `ref` — Affiliate ID (e.g., "vader")
- `source` — Traffic source (e.g., "sector23", "flutter-app")
- `campaign` — Marketing campaign ID

### 3. Sales Dashboard

Real-time metrics:
- **Total Sales** — Revenue in DKK/USD
- **Total Orders** — Count of transactions
- **Average Order Value (AOV)** — Revenue / Orders
- **Conversion Rate** — Purchases / Views

---

## 🔧 Backend API

### Endpoints

#### GET /api/products

```json
{
  "products": [
    {
      "id": "prod_001",
      "name": "Micro-USB Cable (3ft)",
      "price": 3.00,
      "currency": "DKK",
      "category": "Electronics",
      "image_url": "https://...",
      "affiliate_url": "https://amazon.com/dp/B0123?ref=vader",
      "in_stock": true,
      "stock_count": 150
    }
  ],
  "total": 24,
  "page": 1,
  "per_page": 20
}
```

#### GET /api/metrics

```json
{
  "total_sales": 1500.00,
  "total_orders": 500,
  "average_order_value": 3.00,
  "conversion_rate": 0.025,
  "top_products": [
    {"id": "prod_001", "name": "Micro-USB Cable", "sales": 150}
  ],
  "recent_sales": [
    {"product_id": "prod_001", "timestamp": "2026-02-28T14:32:15Z", "ref": "vader"}
  ]
}
```

#### POST /api/sales

Track a sale:
```json
{
  "product_id": "prod_001",
  "ref": "vader",
  "source": "flutter-app",
  "campaign": "imperial-sale-2026"
}
```

Response:
```json
{
  "success": true,
  "sale_id": "sale_12345",
  "commission": 0.15
}
```

---

## 📱 Flutter Integration

### Models

```dart
// lib/src/models/product.dart
class Product {
  final String id;
  final String name;
  final double price;
  final String currency;
  final String category;
  final String imageUrl;
  final String affiliateUrl;
  final bool inStock;
  final int stockCount;
}
```

### Services

```dart
// lib/src/services/product_service.dart
class ProductService {
  Future<List<Product>> getProducts();
  Future<Metrics> getMetrics();
  Future<SaleResult> trackSale(String productId, String ref);
}
```

### Screens

```dart
// lib/src/screens/dollar_store_screen.dart
class DollarStoreScreen extends ConsumerWidget {
  // Product grid
  // Real-time metrics
  // Affiliate tracking
}
```

---

## 🚀 Deployment

### AWS Amplify Configuration

```yaml
# amplify.yml
version: 1
frontend:
  phases:
    build:
      commands:
        - npm run build
  artifacts:
    baseDirectory: build
    files:
      - '**/*'
  cache:
    paths:
      - node_modules/**/*
```

### Environment Variables

```bash
# Backend
DATABASE_URL=postgresql://user:pass@host:5432/dollar_store
AFFILIATE_REF=vader
API_KEY=your_api_key_here

# Frontend
REACT_APP_API_URL=https://api.dollarstore.turbo-empire.tech
FLUTTER_API_URL=https://api.dollarstore.turbo-empire.tech
```

---

## 📊 Metrics & Analytics

### Dashboard Queries

```sql
-- Total sales today
SELECT SUM(amount) FROM sales WHERE DATE(created_at) = CURRENT_DATE;

-- Top products this week
SELECT product_id, COUNT(*) as sales_count 
FROM sales 
WHERE created_at >= NOW() - INTERVAL '7 days'
GROUP BY product_id 
ORDER BY sales_count DESC;

-- Conversion rate by source
SELECT source, 
       COUNT(*) as views, 
       SUM(CASE WHEN purchased THEN 1 ELSE 0 END) as purchases,
       SUM(CASE WHEN purchased THEN 1 ELSE 0 END) * 100.0 / COUNT(*) as conversion_rate
FROM product_views 
GROUP BY source;
```

---

## 🔐 Security

### API Authentication

```javascript
// Middleware
const authenticate = (req, res, next) => {
  const apiKey = req.headers['x-api-key'];
  if (apiKey !== process.env.API_KEY) {
    return res.status(401).json({ error: 'Unauthorized' });
  }
  next();
};
```

### Affiliate Fraud Prevention

- Validate referrer URLs
- Rate limit tracking requests
- Detect bot traffic
- Monitor for click fraud

---

## 📈 Marketing Integration

### Social Media Auto-Posting

```python
# scripts/auto-post.py
# Posts new products to:
# - Twitter (via API)
# - Facebook (via Graph API)
# - Instagram (via Business API)
```

### Email Campaigns

```python
# scripts/email-campaign.py
# Sends weekly deals via:
# - SendGrid
# - AWS SES
# - Mailchimp
```

---

## 🛡️ Related Sectors

| Sector | Purpose |
|--------|---------|
| **17-Flutter** | Mobile app integration |
| **19-Expo** | React Native app |
| **08-AWS** | Cloud infrastructure |
| **09-Security** | API security, fraud detection |

---

*Last Updated: 2026-02-28*
*Vader + Turbo approved — "Everything must go! Even the Empire needs cash flow."*
