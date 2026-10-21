import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/cart_entity.dart';

abstract class CartLocalDataSource {
  Future<Either<Failure, CartEntity>> fetchCart();
}

class CartLocalDataSourceImpl implements CartLocalDataSource {
  @override
  Future<Either<Failure, CartEntity>> fetchCart() async {
    // TODO: return dummy data
    throw UnimplementedError();
  }
}
