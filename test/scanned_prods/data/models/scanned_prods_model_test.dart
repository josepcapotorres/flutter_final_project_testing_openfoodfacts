import 'package:flutter_final_project_testing_openfoodfacts/scanned_prods/data/models/scanned_prod_model.dart';
import 'package:flutter_final_project_testing_openfoodfacts/scanned_prods/domain/entities/scanned_prod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test("should be a subclass of ScannedProds entity", () {
    // Arrange
    final model = ScannedProdModel(
      "4802784957",
      "Atún",
      "https://domain.com",
      DateTime.now(),
    );

    // Assert
    expect(model, isA<ScannedProd>());
  });

  group("json formats on deserializing to the model", () {
    test("should deserialize the json correctly", () {
      // Arrange
      final json = {
        "code": "4802784957",
        "product": {"product_name_es": "Cebolla encurtida"},
        "selected_images": {
          "front": {
            "small": {"en": "https://domain.com"},
          }
        },
        "inserted_at": DateTime.now().toIso8601String(),
      };

      // Act
      final product = ScannedProdModel.fromJson(json);

      // Assert
      expect(product.barcode, "4802784957");
    });

    test(
        "should throw an exception because of a problem on deserializing a json data type value",
        () {
      // Arrange
      final json = {
        "code": 4802784957,
        "product": {"product_name_es": "Cebolla encurtida"},
        "selected_images": {
          "front": {
            "small": {"en": "https://domain.com"},
          }
        },
        "inserted_at": DateTime.now().toIso8601String(),
      };

      // Assert
      expect(() => ScannedProdModel.fromJson(json), throwsA(isA<TypeError>()));
    });

    test(
        "should throw an exception because of a problem on deserializing a wrong key name",
        () {
      // Arrange
      final json = {
        "code": "4802784957",
        "product": {"product_na": "Cebolla encurtida"},
        "selected_images": {
          "front": {
            "small": {"en": "https://domain.com"},
          }
        },
        "inserted_at": DateTime.now().toIso8601String(),
      };

      // Assert
      expect(() => ScannedProdModel.fromJson(json), throwsA(isA<TypeError>()));
    });
  });

  group("properties class on serializing to the json", () {
    test("should serialize the object correctly", () {
      // Arrange
      final model = ScannedProdModel(
        "4802784957",
        "Cebolla encurtida",
        "https://domain.com",
        DateTime(2025, 08, 23),
      );

      final json = {
        "code": "4802784957",
        "product": {
          "product_name_es": "Cebolla encurtida",
          "selected_images": {
            "front": {
              "small": {"en": "https://domain.com"},
            }
          },
        },
        "inserted_at": DateTime(2025, 08, 23).toIso8601String(),
      };

      // Act
      final product = model.toJson();

      // Assert
      expect(product, json);
    });
  });
}
