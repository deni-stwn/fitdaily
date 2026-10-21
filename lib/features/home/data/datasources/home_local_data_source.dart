import 'dart:convert';

import 'package:flutter/services.dart';

import '../../../../core/constants/dummy_assets.dart';
import '../../../../shared/models/pagination/pagination_params.dart';
import '../../domain/entities/product/product_entity.dart';
import '../models/product/product_model.dart';

abstract class HomeLocalDataSource {
  Future<List<ProductEntity>> fetchProducts(PaginationParams params);
}

/// Reads products from a dummy JSON asset (no backend).
/// Replace with a remote data source once an API is available.
class HomeLocalDataSourceImpl implements HomeLocalDataSource {
  HomeLocalDataSourceImpl();

  @override
  Future<List<ProductEntity>> fetchProducts(PaginationParams params) async {
    // Simulates latency so loading/shimmer states stay visible while slicing.
    await Future.delayed(const Duration(milliseconds: 500));

    final raw = await rootBundle.loadString(DummyAssets.products);
    final json = jsonDecode(raw) as Map<String, dynamic>;

    return (json['products'] as List)
        .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
        .skip(params.skip)
        .take(params.limit)
        .toList();
  }
}
