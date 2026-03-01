/// =============================================================================
/// Sector 23 — $3 Dollar Store API Service
/// Connects Flutter app to Node.js/Express backend
/// =============================================================================

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'models/product.dart';

/// API Service for $3 Dollar Store
class DollarStoreService {
  final String baseUrl;
  final String? apiKey;
  final http.Client client;

  DollarStoreService({
    this.baseUrl = 'https://api.dollarstore.turbo-empire.tech',
    this.apiKey,
    http.Client? client,
  }) : client = client ?? http.Client();

  /// Get all products (paginated)
  Future<List<Product>> getProducts({
    int page = 1,
    int perPage = 20,
    String? category,
  }) async {
    final uri = Uri.parse('$baseUrl/api/products').replace(
      queryParameters: {
        'page': page.toString(),
        'per_page': perPage.toString(),
        if (category != null) 'category': category,
      },
    );

    final response = await _makeRequest(uri);
    final data = json.decode(response.body) as Map<String, dynamic>;
    
    final products = (data['products'] as List)
        .map((p) => Product.fromJson(p as Map<String, dynamic>))
        .toList();

    return products;
  }

  /// Get single product by ID
  Future<Product> getProductById(String id) async {
    final uri = Uri.parse('$baseUrl/api/products/$id');
    final response = await _makeRequest(uri);
    final data = json.decode(response.body) as Map<String, dynamic>;
    return Product.fromJson(data);
  }

  /// Get store metrics (dashboard data)
  Future<StoreMetrics> getMetrics() async {
    final uri = Uri.parse('$baseUrl/api/metrics');
    final response = await _makeRequest(uri);
    final data = json.decode(response.body) as Map<String, dynamic>;
    return StoreMetrics.fromJson(data);
  }

  /// Track a sale (affiliate marketing)
  Future<SaleResult> trackSale(SaleTrackRequest request) async {
    final uri = Uri.parse('$baseUrl/api/sales');
    
    final response = await client.post(
      uri,
      headers: _headers,
      body: json.encode(request.toJson()),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw ApiException('Failed to track sale: ${response.statusCode}');
    }

    final data = json.decode(response.body) as Map<String, dynamic>;
    return SaleResult.fromJson(data);
  }

  /// Search products
  Future<List<Product>> searchProducts(String query) async {
    final uri = Uri.parse('$baseUrl/api/search').replace(
      queryParameters: {'q': query},
    );

    final response = await _makeRequest(uri);
    final data = json.decode(response.body) as Map<String, dynamic>;
    
    return (data['products'] as List)
        .map((p) => Product.fromJson(p as Map<String, dynamic>))
        .toList();
  }

  /// Get products by category
  Future<List<Product>> getProductsByCategory(String category) async {
    return getProducts(category: category);
  }

  /// Build affiliate URL with tracking parameters
  String buildAffiliateUrl({
    required String baseUrl,
    required String ref,
    String? source,
    String? campaign,
  }) {
    final uri = Uri.parse(baseUrl).replace(
      queryParameters: {
        'ref': ref,
        if (source != null) 'source': source,
        if (campaign != null) 'campaign': campaign,
      },
    );
    return uri.toString();
  }

  /// Make authenticated HTTP request
  Future<http.Response> _makeRequest(Uri uri) async {
    final response = await client.get(
      uri,
      headers: _headers,
    );

    if (response.statusCode != 200) {
      throw ApiException('Request failed: ${response.statusCode}');
    }

    return response;
  }

  /// HTTP headers for API requests
  Map<String, String> get _headers {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (apiKey != null) 'X-API-Key': apiKey!,
    };
  }

  /// Dispose of HTTP client
  void dispose() {
    client.close();
  }
}

/// =============================================================================
/// API Exception
/// =============================================================================

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, {this.statusCode});

  @override
  String toString() => 'ApiException: $message';
}
