import '../entities/scanned_prod.dart';

abstract class ScannedProdsRepository {
  Future<List<ScannedProd>> getPreviousScannedProds();
}
