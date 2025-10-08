import '../../domain/entities/scanned_prod.dart';
import '../../domain/repositories/scanned_prods_repository.dart';
import '../datasources/scanned_prods_local_data_source.dart';

class ScannedProdsRepositoryImpl extends ScannedProdsRepository {
  final ScannedProdsLocalDataSource localDataSource;

  ScannedProdsRepositoryImpl({required this.localDataSource});

  @override
  Future<List<ScannedProd>> getPreviousScannedProds() async {
    return await localDataSource.getPreviousScannedProds();
  }
}
