import 'package:dartz/dartz.dart';

import '../../../core/failures/failure.dart';
import '../entities/product.dart';

abstract class ProdsScanningRepository {
  Future<Either<Failure, Product>> scanAndGetProductDetails();

  Future<Either<Failure, Product>> getProductDetails(String barcode);
}
