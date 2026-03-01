/// =============================================================================
/// Sector 23 — $3 Dollar Store Product Model
/// Everything costs exactly 3 DKK (or equivalent)
/// =============================================================================

import 'package:equatable/equatable.dart';

/// Product model for $3 Dollar Store inventory
class Product extends Equatable {
  final String id;
  final String name;
  final double price;
  final String currency;
  final String category;
  final String imageUrl;
  final String affiliateUrl;
  final bool inStock;
  final int stockCount;
  final String? description;
  final List<String> tags;

  const Product({
    required this.id,
    required this.name,
    required this.price,
    this.currency = 'DKK',
    required this.category,
    required this.imageUrl,
    required this.affiliateUrl,
    this.inStock = true,
    this.stockCount = 0,
    this.description,
    this.tags = const [],
  });

  /// Factory constructor from JSON (API response)
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as String,
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      currency: json['currency'] as String? ?? 'DKK',
      category: json['category'] as String,
      imageUrl: json['image_url'] as String,
      affiliateUrl: json['affiliate_url'] as String,
      inStock: json['in_stock'] as bool? ?? true,
      stockCount: json['stock_count'] as int? ?? 0,
      description: json['description'] as String?,
      tags: json['tags'] != null 
          ? List<String>.from(json['tags'] as List) 
          : [],
    );
  }

  /// Convert to JSON (for API requests)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'currency': currency,
      'category': category,
      'image_url': imageUrl,
      'affiliate_url': affiliateUrl,
      'in_stock': inStock,
      'stock_count': stockCount,
      'description': description,
      'tags': tags,
    };
  }

  /// Copy with immutable state updates
  Product copyWith({
    String? id,
    String? name,
    double? price,
    String? currency,
    String? category,
    String? imageUrl,
    String? affiliateUrl,
    bool? inStock,
    int? stockCount,
    String? description,
    List<String>? tags,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      currency: currency ?? this.currency,
      category: category ?? this.category,
      imageUrl: imageUrl ?? this.imageUrl,
      affiliateUrl: affiliateUrl ?? this.affiliateUrl,
      inStock: inStock ?? this.inStock,
      stockCount: stockCount ?? this.stockCount,
      description: description ?? this.description,
      tags: tags ?? this.tags,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        price,
        currency,
        category,
        imageUrl,
        affiliateUrl,
        inStock,
        stockCount,
        description,
        tags,
      ];
}

/// =============================================================================
/// Store Metrics Model
/// Real-time sales dashboard data
/// =============================================================================

class StoreMetrics extends Equatable {
  final double totalSales;
  final int totalOrders;
  final double averageOrderValue;
  final double conversionRate;
  final List<ProductSale> topProducts;
  final List<RecentSale> recentSales;
  final DateTime lastUpdated;

  const StoreMetrics({
    required this.totalSales,
    required this.totalOrders,
    required this.averageOrderValue,
    required this.conversionRate,
    required this.topProducts,
    required this.recentSales,
    required this.lastUpdated,
  });

  factory StoreMetrics.fromJson(Map<String, dynamic> json) {
    return StoreMetrics(
      totalSales: (json['total_sales'] as num).toDouble(),
      totalOrders: json['total_orders'] as int,
      averageOrderValue: (json['average_order_value'] as num).toDouble(),
      conversionRate: (json['conversion_rate'] as num).toDouble(),
      topProducts: (json['top_products'] as List)
          .map((p) => ProductSale.fromJson(p))
          .toList(),
      recentSales: (json['recent_sales'] as List)
          .map((s) => RecentSale.fromJson(s))
          .toList(),
      lastUpdated: DateTime.parse(json['last_updated'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_sales': totalSales,
      'total_orders': totalOrders,
      'average_order_value': averageOrderValue,
      'conversion_rate': conversionRate,
      'top_products': topProducts.map((p) => p.toJson()).toList(),
      'recent_sales': recentSales.map((s) => s.toJson()).toList(),
      'last_updated': lastUpdated.toIso8601String(),
    };
  }

  StoreMetrics copyWith({
    double? totalSales,
    int? totalOrders,
    double? averageOrderValue,
    double? conversionRate,
    List<ProductSale>? topProducts,
    List<RecentSale>? recentSales,
    DateTime? lastUpdated,
  }) {
    return StoreMetrics(
      totalSales: totalSales ?? this.totalSales,
      totalOrders: totalOrders ?? this.totalOrders,
      averageOrderValue: averageOrderValue ?? this.averageOrderValue,
      conversionRate: conversionRate ?? this.conversionRate,
      topProducts: topProducts ?? this.topProducts,
      recentSales: recentSales ?? this.recentSales,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  @override
  List<Object?> get props => [
        totalSales,
        totalOrders,
        averageOrderValue,
        conversionRate,
        topProducts,
        recentSales,
        lastUpdated,
      ];
}

/// =============================================================================
/// Product Sale Model (for top products)
/// =============================================================================

class ProductSale extends Equatable {
  final String id;
  final String name;
  final int salesCount;
  final double revenue;

  const ProductSale({
    required this.id,
    required this.name,
    required this.salesCount,
    required this.revenue,
  });

  factory ProductSale.fromJson(Map<String, dynamic> json) {
    return ProductSale(
      id: json['id'] as String,
      name: json['name'] as String,
      salesCount: json['sales_count'] as int,
      revenue: (json['revenue'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'sales_count': salesCount,
      'revenue': revenue,
    };
  }

  @override
  List<Object?> get props => [id, name, salesCount, revenue];
}

/// =============================================================================
/// Recent Sale Model
/// =============================================================================

class RecentSale extends Equatable {
  final String productId;
  final String productName;
  final DateTime timestamp;
  final String ref;
  final String? source;
  final double amount;

  const RecentSale({
    required this.productId,
    required this.productName,
    required this.timestamp,
    required this.ref,
    this.source,
    required this.amount,
  });

  factory RecentSale.fromJson(Map<String, dynamic> json) {
    return RecentSale(
      productId: json['product_id'] as String,
      productName: json['product_name'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      ref: json['ref'] as String,
      source: json['source'] as String?,
      amount: (json['amount'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'product_name': productName,
      'timestamp': timestamp.toIso8601String(),
      'ref': ref,
      'source': source,
      'amount': amount,
    };
  }

  @override
  List<Object?> get props => [
        productId,
        productName,
        timestamp,
        ref,
        source,
        amount,
      ];
}

/// =============================================================================
/// Sale Tracking Request Model
/// =============================================================================

class SaleTrackRequest extends Equatable {
  final String productId;
  final String ref;
  final String source;
  final String? campaign;

  const SaleTrackRequest({
    required this.productId,
    required this.ref,
    required this.source,
    this.campaign,
  });

  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'ref': ref,
      'source': source,
      'campaign': campaign,
    };
  }

  @override
  List<Object?> get props => [productId, ref, source, campaign];
}

/// =============================================================================
/// Sale Tracking Response Model
/// =============================================================================

class SaleResult extends Equatable {
  final bool success;
  final String saleId;
  final double commission;
  final String? message;

  const SaleResult({
    required this.success,
    required this.saleId,
    required this.commission,
    this.message,
  });

  factory SaleResult.fromJson(Map<String, dynamic> json) {
    return SaleResult(
      success: json['success'] as bool,
      saleId: json['sale_id'] as String,
      commission: (json['commission'] as num).toDouble(),
      message: json['message'] as String?,
    );
  }

  @override
  List<Object?> get props => [success, saleId, commission, message];
}
