import 'package:flutter_clean_architecture_template/core/errors/failures.dart';
import 'package:flutter_clean_architecture_template/features/home/data/datasources/home_local_data_source.dart';
import 'package:flutter_clean_architecture_template/features/home/data/repositories/home_repository_impl.dart';
import 'package:flutter_clean_architecture_template/features/home/domain/entities/product/product_entity.dart';
import 'package:flutter_clean_architecture_template/shared/models/pagination/pagination_params.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/product_test_fixtures.dart';

class _FakeLocal implements HomeLocalDataSource {
  Object? throwError;
  List<ProductEntity> products = [];
  PaginationParams? lastParams;

  @override
  Future<List<ProductEntity>> fetchProducts(PaginationParams params) async {
    lastParams = params;
    if (throwError != null) {
      throw throwError!;
    }
    return products;
  }
}

void main() {
  late _FakeLocal local;
  late HomeRepositoryImpl repository;

  setUp(() {
    local = _FakeLocal();
    repository = HomeRepositoryImpl(localDataSource: local);
  });

  test('returns local products and forwards params', () async {
    final products = [createProductModel(id: 1)];
    local.products = products;

    final result = await repository.getProduct(
      const PaginationParams(skip: 10, limit: 5),
    );

    expect(result.isRight(), isTrue);
    result.fold((_) => fail('expected success'), (value) {
      expect(value, products);
    });
    expect(local.lastParams?.skip, 10);
    expect(local.lastParams?.limit, 5);
  });

  test('returns failure when local data source throws', () async {
    local.throwError = const FormatException('bad json');

    final result = await repository.getProduct(const PaginationParams());

    expect(result.isLeft(), isTrue);
    result.fold(
      (failure) => expect(failure, isA<Failure>()),
      (_) => fail('expected failure'),
    );
  });
}
