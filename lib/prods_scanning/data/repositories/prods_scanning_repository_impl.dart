import 'package:dartz/dartz.dart';
import 'package:flutter_final_project_testing_openfoodfacts/data/services/crash_reporter_service.dart';
import 'package:flutter_final_project_testing_openfoodfacts/prods_scanning/data/datasources/prods_scanning_barcode_scanner_datasource.dart';
import 'package:flutter_final_project_testing_openfoodfacts/prods_scanning/data/datasources/prods_scanning_local_datasource.dart';
import 'package:flutter_final_project_testing_openfoodfacts/prods_scanning/data/datasources/prods_scanning_remote_datasource.dart';

import '../../../core/failures/failure.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/prods_scanning_repository.dart';

class ProdsScanningRepositoryImpl extends ProdsScanningRepository {
  final ProdsScanningRemoteDatasource remoteDatasource;
  final ProdsScanningLocalDatasource localDatasource;
  final ProdsScanningBarcodeScannerDataSource barcodeScannerDataSource;
  final CrashReporterService reporterService;

  ProdsScanningRepositoryImpl({
    required this.remoteDatasource,
    required this.localDatasource,
    required this.barcodeScannerDataSource,
    required this.reporterService,
  });

  @override
  Future<Either<Failure, Product>> getProductDetails(String barcode) async {
    final scannedProdInBd = await localDatasource.getScannedProd(barcode);

    if (scannedProdInBd != null) {
      return Right(scannedProdInBd);
    }

    try {
      final productDetails =
          await remoteDatasource.fetchProductDetails(barcode);

      if (productDetails.status == 1) {
        await localDatasource.cacheScannedProd(productDetails);

        return Right(productDetails);
      } else {
        return Left(ProductNotFoundFailure());
      }
    } catch (e, stack) {
      await reporterService.log("barcode: $barcode");
      await reporterService.recordError(e, stack);

      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Product>> scanAndGetProductDetails() async {
    final barcode = await barcodeScannerDataSource.scanProduct();

    if (barcode == null || barcode.isEmpty) return Left(ScanCancelledFailure());

    return await getProductDetails(barcode);
  }
}
