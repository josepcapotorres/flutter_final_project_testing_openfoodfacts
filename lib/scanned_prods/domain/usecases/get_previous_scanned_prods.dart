import '../entities/scanned_prod.dart';
import '../repositories/scanned_prods_repository.dart';

class GetPreviousScannedProds {
  final ScannedProdsRepository _repository;

  GetPreviousScannedProds(this._repository);

  Future<List<ScannedProd>> call() async {
    final products = await _repository.getPreviousScannedProds();

    products.sort((a, b) => b.insertedAt.compareTo(a.insertedAt));

    return products;
  }
}
