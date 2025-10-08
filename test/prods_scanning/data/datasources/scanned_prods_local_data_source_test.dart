import 'package:flutter_final_project_testing_openfoodfacts/prods_scanning/data/datasources/prods_scanning_local_datasource.dart';
import 'package:flutter_final_project_testing_openfoodfacts/prods_scanning/data/models/product_model.dart';
import 'package:flutter_final_project_testing_openfoodfacts/prods_scanning/data/models/product_nutrients_model.dart';
import 'package:flutter_final_project_testing_openfoodfacts/prods_scanning/domain/entities/product.dart';
import 'package:flutter_final_project_testing_openfoodfacts/prods_scanning/domain/entities/product_nutrients.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:mocktail/mocktail.dart';

class MockBox extends Mock implements Box<Map<String, dynamic>> {}

void main() {
  late ProdsScanningLocalDatasourceImpl sut;
  late MockBox mockBox;

  setUp(() {
    mockBox = MockBox();
    sut = ProdsScanningLocalDatasourceImpl(mockBox);
  });

  final productModel = ProductModel(
    "Nutella",
    "E",
    "https://www.domain.com",
    "048938629",
    ProcessingFoodType.processed,
    ProductNutrientsModel(
      ProcessingProductNutrientLevel.low,
      ProcessingProductNutrientLevel.low,
      ProcessingProductNutrientLevel.low,
      ProcessingProductNutrientLevel.low,
    ),
  );

  test("should cache the scanned product successfuly", () async {
    // Arrange
    when(() => mockBox.put(productModel.barcode, productModel.toJson()))
        .thenAnswer((_) async {});

    // Act
    await sut.cacheScannedProd(productModel);

    // Assert
    verify(() => mockBox.put(productModel.barcode, productModel.toJson()))
        .called(1);
  });

  group("getPreviousScannedProds", () {
    test("should return a filled list", () async {
      // Arrange
      when(() => mockBox.values).thenReturn([productModel.toJson()]);

      // Act
      final products = await sut.getPreviousScannedProds();

      // Assert
      verify(() => mockBox.values).called(1);
      expect(products.length, 1);
    });

    test("should return an empty list", () async {
      // Arrange
      when(() => mockBox.values).thenReturn([]);

      // Act
      final products = await sut.getPreviousScannedProds();

      // Assert
      verify(() => mockBox.values).called(1);
      expect(products, []);
    });
  });
}
