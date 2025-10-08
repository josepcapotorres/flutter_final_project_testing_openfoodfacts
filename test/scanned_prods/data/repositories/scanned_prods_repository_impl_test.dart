import 'package:flutter_final_project_testing_openfoodfacts/scanned_prods/data/datasources/scanned_prods_local_data_source.dart';
import 'package:flutter_final_project_testing_openfoodfacts/scanned_prods/data/models/scanned_prod_model.dart';
import 'package:flutter_final_project_testing_openfoodfacts/scanned_prods/data/repositories/scanned_prods_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockScannedProdsLocalDataSource extends Mock
    implements ScannedProdsLocalDataSource {}

void main() {
  late MockScannedProdsLocalDataSource mockLocalDataSource;
  late ScannedProdsRepositoryImpl scannedProdsRepositoryImpl;

  setUp(() {
    mockLocalDataSource = MockScannedProdsLocalDataSource();
    scannedProdsRepositoryImpl =
        ScannedProdsRepositoryImpl(localDataSource: mockLocalDataSource);
  });

  test("should retrieve a list of ScannedProdsModel", () async {
    // Arrange
    final products = [
      ScannedProdModel(
        "4802784957",
        "Cebolla encurtida",
        "https://domain.com",
        DateTime(2025, 08, 23),
      ),
      ScannedProdModel(
        "4802784957",
        "Cebolla encurtida",
        "https://domain.com",
        DateTime(2025, 07, 23),
      )
    ];

    when(() => mockLocalDataSource.getPreviousScannedProds()).thenAnswer(
      (_) async => products,
    );

    // Act
    final result = await scannedProdsRepositoryImpl.getPreviousScannedProds();

    // Assert
    expect(products, result);
    verify(() => mockLocalDataSource.getPreviousScannedProds()).called(1);
  });

  test("should retrieve a list of ScannedProdsModel", () async {
    // Arrange
    final products = <ScannedProdModel>[];

    when(() => mockLocalDataSource.getPreviousScannedProds()).thenAnswer(
      (_) async => products,
    );

    // Act
    final result = await scannedProdsRepositoryImpl.getPreviousScannedProds();

    // Assert
    expect(products, result);
    verify(() => mockLocalDataSource.getPreviousScannedProds()).called(1);
  });
}
