import 'package:flutter_final_project_testing_openfoodfacts/prods_scanning/data/models/product_model.dart';
import 'package:flutter_final_project_testing_openfoodfacts/prods_scanning/domain/entities/product.dart';
import 'package:flutter_final_project_testing_openfoodfacts/prods_scanning/domain/entities/product_nutrients.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test("should be a subclass of Product entity", () {
    // Arrange
    final productModel = ProductModel(
      1,
      "Product name",
      "E",
      "https://www.domain.com",
      "3017620425035",
      ProcessingFoodType.withoutOrMinimumProcessed,
      ProductNutrients(
        ProcessingProductNutrientLevel.low,
        ProcessingProductNutrientLevel.low,
        ProcessingProductNutrientLevel.low,
        ProcessingProductNutrientLevel.low,
      ),
    );

    // Assert
    expect(productModel, isA<Product>());
  });

  test("should deserialize the data properly", () {
    // Arrange
    final json = {
      "status": 1,
      "product": {
        "product_name_es": "Nutella",
        "nutrition_grades": "E",
        "selected_images": {
          "front": {
            "small": {"en": "https://www.domain.com"}
          }
        },
      },
      "code": "3017620425035",
      "nutriments": {"nova-group": 3},
    };

    // Act
    final productModel = ProductModel.fromJson(json);

    // Assert
    expect(productModel.productName, "Nutella");
  });

  test("should deserialize the data wrongly", () {
    // Arrange
    final json = {
      "status": 1,
      "product": {},
      "code": "3017620425035",
      "nutriments": {"nova-group": 3},
    };

    // act
    final productModel = ProductModel.fromJson(json);

    // Assert
    expect(productModel.productName, "-");
  });
}
