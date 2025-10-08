import 'package:flutter_final_project_testing_openfoodfacts/scanned_prods/data/datasources/scanned_prods_local_data_source.dart';
import 'package:flutter_final_project_testing_openfoodfacts/scanned_prods/data/models/scanned_prod_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:mocktail/mocktail.dart';

class MockBox extends Mock implements Box<Map<String, dynamic>> {}

void main() {
  late MockBox mockBox;
  late ScannedProdsLocalDataSourceImpl scannedProdsLocalDataSource;

  setUp(() {
    mockBox = MockBox();
    scannedProdsLocalDataSource = ScannedProdsLocalDataSourceImpl(mockBox);
  });

  test("should retrieve a list of scanned products correctly", () async {
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

    when(() => mockBox.values).thenReturn(products.map((e) => e.toJson()));

    // Act
    final results = await scannedProdsLocalDataSource.getPreviousScannedProds();

    // Assert
    expect(products, results);
    verify(() => mockBox.values).called(1);
  });

  test("should retrieve a list of empty scanned products correctly", () async {
    // Arrange
    final products = <ScannedProdModel>[];

    when(() => mockBox.values).thenReturn(products.map((e) => e.toJson()));

    // Act
    final results = await scannedProdsLocalDataSource.getPreviousScannedProds();

    // Assert
    expect(products, results);
    verify(() => mockBox.values).called(1);
  });
}
