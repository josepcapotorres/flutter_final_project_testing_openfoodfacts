import 'package:dartz/dartz.dart';
import 'package:flutter_final_project_testing_openfoodfacts/core/exceptions/exceptions.dart';
import 'package:flutter_final_project_testing_openfoodfacts/core/failures/failure.dart';
import 'package:flutter_final_project_testing_openfoodfacts/prods_scanning/data/datasources/prods_scanning_barcode_scanner_datasource.dart';
import 'package:flutter_final_project_testing_openfoodfacts/prods_scanning/data/datasources/prods_scanning_local_datasource.dart';
import 'package:flutter_final_project_testing_openfoodfacts/prods_scanning/data/datasources/prods_scanning_remote_datasource.dart';
import 'package:flutter_final_project_testing_openfoodfacts/prods_scanning/data/models/product_model.dart';
import 'package:flutter_final_project_testing_openfoodfacts/prods_scanning/data/repositories/prods_scanning_repository_impl.dart';
import 'package:flutter_final_project_testing_openfoodfacts/prods_scanning/domain/entities/product.dart';
import 'package:flutter_final_project_testing_openfoodfacts/prods_scanning/domain/entities/product_nutrients.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockProdsScanningLocalDataSource extends Mock
    implements ProdsScanningLocalDatasource {}

class MockProdsScanningRemoteDataSource extends Mock
    implements ProdsScanningRemoteDatasource {}

class MockProdsScanningBarcodeScannerDataSource extends Mock
    implements ProdsScanningBarcodeScannerDataSource {}

void main() {
  late ProdsScanningRepositoryImpl sut;
  late MockProdsScanningRemoteDataSource mockRemoteDataSource;
  late MockProdsScanningLocalDataSource mockLocalDataSource;
  late MockProdsScanningBarcodeScannerDataSource mockScanningDataSource;

  setUp(() {
    mockRemoteDataSource = MockProdsScanningRemoteDataSource();
    mockLocalDataSource = MockProdsScanningLocalDataSource();
    mockScanningDataSource = MockProdsScanningBarcodeScannerDataSource();

    sut = ProdsScanningRepositoryImpl(
      remoteDatasource: mockRemoteDataSource,
      localDatasource: mockLocalDataSource,
      barcodeScannerDataSource: mockScanningDataSource,
    );
  });

  final barcode = "048938629";

  final productModel = ProductModel(
    1,
    "Nutella",
    "E",
    "https://www.domain.com",
    "048938629",
    ProcessingFoodType.processed,
    ProductNutrients(
      ProcessingProductNutrientLevel.low,
      ProcessingProductNutrientLevel.low,
      ProcessingProductNutrientLevel.low,
      ProcessingProductNutrientLevel.low,
    ),
  );

  group(
    "getProductDetails",
    () {
      test(
          "should retrieve the existing selected product from the local datasource",
          () async {
        // Arrange
        when(() => mockLocalDataSource.getScannedProd(barcode)).thenAnswer(
          (_) async => productModel,
        );

        // Act
        final productDetails = await sut.getProductDetails(barcode);

        // Assert
        verify(() => mockLocalDataSource.getScannedProd(barcode)).called(1);
        expect(productDetails, Right(productModel));
      });

      test("should retrieve the selected product from the remote datasource",
          () async {
        // Arrange
        when(() => mockLocalDataSource.getScannedProd(barcode)).thenAnswer(
          (_) async => null,
        );

        when(() => mockRemoteDataSource.fetchProductDetails(barcode))
            .thenAnswer(
          (_) async => productModel,
        );

        when(() => mockLocalDataSource.cacheScannedProd(productModel))
            .thenAnswer((_) async => Future.value());

        // Act
        final productDetails = await sut.getProductDetails(barcode);

        // Assert
        verify(() => mockLocalDataSource.getScannedProd(barcode)).called(1);
        verify(() => mockRemoteDataSource.fetchProductDetails(barcode))
            .called(1);
        verify(() => mockLocalDataSource.cacheScannedProd(productModel))
            .called(1);

        expect(productDetails, Right(productModel));
      });

      test("should return a ServerFailure if any error has been detected",
          () async {
        // Arrange
        when(() => mockLocalDataSource.getScannedProd(barcode)).thenAnswer(
          (_) async => null,
        );

        when(() => mockRemoteDataSource.fetchProductDetails(barcode)).thenThrow(
          ServerException(),
        );

        // Act
        final productDetails = await sut.getProductDetails(barcode);

        // Assert
        expect(productDetails, Left(ServerFailure()));
      });
    },
  );

  group("scanAndGetProductDetails", () {
    test("should return product details after successful barcode scan",
        () async {
      // Arrange
      when(() => mockScanningDataSource.scanProduct())
          .thenAnswer((_) async => barcode);
      when(() => mockLocalDataSource.getScannedProd(barcode))
          .thenAnswer((_) async => null);
      when(() => mockRemoteDataSource.fetchProductDetails(barcode))
          .thenAnswer((_) async => productModel);
      when(() => mockLocalDataSource.cacheScannedProd(productModel))
          .thenAnswer((_) async => Future.value());

      // Act
      final result = await sut.scanAndGetProductDetails();

      // Assert
      expect(result, Right(productModel));
    });
  });

  test("should return a ScanCancelledFailure if scan result is null or empty",
      () async {
    // Arrange
    when(() => mockScanningDataSource.scanProduct())
        .thenAnswer((_) async => null);

    // Act
    final result = await sut.scanAndGetProductDetails();

    // Assert
    expect(result, Left(ScanCancelledFailure()));
  });
}
