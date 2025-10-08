import 'package:dartz/dartz.dart';

import '../../../core/failures/failure.dart';
import '../entities/product.dart';
import '../repositories/prods_scanning_repository.dart';

class ScanAndGetProductDetails {
  final ProdsScanningRepository _repository;

  ScanAndGetProductDetails(this._repository);

  Future<Either<Failure, Product>> call() async {
    return await _repository.scanAndGetProductDetails();
  }
}
