import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_final_project_testing_openfoodfacts/core/network/network_info.dart';
import 'package:flutter_final_project_testing_openfoodfacts/data/services/crash_reporter_service.dart';
import 'package:flutter_final_project_testing_openfoodfacts/prods_scanning/domain/usecases/get_product_details.dart';
import 'package:flutter_final_project_testing_openfoodfacts/prods_scanning/domain/usecases/scan_and_get_product_details.dart';
import 'package:flutter_final_project_testing_openfoodfacts/prods_scanning/presentation/blocs/prods_scanning_cubit.dart';
import 'package:flutter_final_project_testing_openfoodfacts/scanned_prods/data/datasources/scanned_prods_local_data_source.dart';
import 'package:flutter_final_project_testing_openfoodfacts/scanned_prods/data/repositories/scanned_prods_repository_impl.dart';
import 'package:flutter_final_project_testing_openfoodfacts/scanned_prods/domain/repositories/scanned_prods_repository.dart';
import 'package:flutter_final_project_testing_openfoodfacts/scanned_prods/domain/usecases/get_previous_scanned_prods.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

import 'prods_scanning/data/datasources/prods_scanning_barcode_scanner_datasource.dart';
import 'prods_scanning/data/datasources/prods_scanning_local_datasource.dart';
import 'prods_scanning/data/datasources/prods_scanning_remote_datasource.dart';
import 'prods_scanning/data/repositories/prods_scanning_repository_impl.dart';
import 'prods_scanning/domain/repositories/prods_scanning_repository.dart';
import 'scanned_prods/presentation/blocs/scanned_prods_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Features - Previous scanned products
  // Cubit
  sl.registerFactory(() => ScannedProdsCubit(sl()));
  sl.registerFactory(() => ProdsScanningCubit(sl(), sl()));

  // Use cases
  sl.registerLazySingleton(() => GetPreviousScannedProds(sl()));
  sl.registerLazySingleton(() => GetProductDetails(sl()));
  sl.registerLazySingleton(() => ScanAndGetProductDetails(sl()));

  // Repository
  sl.registerLazySingleton<ScannedProdsRepository>(
    () => ScannedProdsRepositoryImpl(localDataSource: sl()),
  );
  sl.registerLazySingleton<ProdsScanningRepository>(
    () => ProdsScanningRepositoryImpl(
      remoteDatasource: sl(),
      localDatasource: sl(),
      barcodeScannerDataSource: sl(),
      reporterService: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<ScannedProdsLocalDataSource>(
    () => ScannedProdsLocalDataSourceImpl(sl()),
  );

  sl.registerLazySingleton<ProdsScanningRemoteDatasource>(
      () => ProdsScanningRemoteDatasourceImpl(sl(), sl()));
  sl.registerLazySingleton<ProdsScanningLocalDatasource>(
      () => ProdsScanningLocalDatasourceImpl(sl()));
  sl.registerLazySingleton<ProdsScanningBarcodeScannerDataSource>(
      () => ProdsScanningBarcodeScannerDataSourceImpl());

  // External
  sl.registerSingletonAsync<Box<dynamic>>(
    () async {
      final appDir = await getApplicationDocumentsDirectory();

      Hive.init(appDir.path);

      return await Hive.openBox<dynamic>('scanned_prods');
    },
  );

  sl.registerLazySingleton<http.Client>(() => http.Client());
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
  sl.registerLazySingleton<Connectivity>(() => Connectivity());

  sl.registerLazySingleton<CrashReporterService>(
    () => CrashReporterService(FirebaseCrashlytics.instance),
  );

  // Wait all async dependencies to have finished
  await sl.allReady();
}
