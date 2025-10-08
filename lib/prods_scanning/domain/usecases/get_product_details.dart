import 'package:dartz/dartz.dart';

import '../../../core/failures/failure.dart';
import '../entities/product.dart';
import '../repositories/prods_scanning_repository.dart';

class GetProductDetails {
  final ProdsScanningRepository _repository;

  const GetProductDetails(this._repository);

  Future<Either<Failure, Product>> call(String barcode) async {
    return await _repository.getProductDetails(barcode);
  }
}
