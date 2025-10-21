import '../../domain/entities/product.dart';
import '../../domain/entities/product_nutrients.dart';
import 'product_nutrients_model.dart';

class ProductModel extends Product {
  const ProductModel(
    super.productName,
    super.nutriscoreScore,
    super.productImgUrl,
    super.barcode,
    super.processingFoodType,
    super.productNutrient,
  );

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      json["product"]?["product_name_es"] ?? "-",
      json["product"]?["nutrition_grades"] ?? "-",
      json["product"]?["selected_images"]?["front"]?["small"]?["en"] ?? "-",
      json["code"] as String,
      _processingFoodFromJson(
        json["product"]?["nutriments"]?["nova-group"] ?? -1,
      ),
      _nutrientLevelsFromJson(json["product"]?["nutrient_levels"]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "product": {
        "product_name_es": productName,
        "nutrition_grades": nutriscoreScore,
        "selected_images": {
          "front": {
            "small": {"en": productImgUrl}
          }
        },
        "nutriments": {
          "nova-group": _processingFoodToJson(),
        },
        "nutrient_levels":
            (productNutrient as ProductNutrientsModel?)?.toJson(),
      },
      "code": barcode,
    };
  }

  static ProcessingFoodType _processingFoodFromJson(int novaGroupValue) {
    return switch (novaGroupValue) {
      1 => ProcessingFoodType.withoutOrMinimumProcessed,
      2 => ProcessingFoodType.processedCulinaryIngs,
      3 => ProcessingFoodType.processed,
      4 => ProcessingFoodType.ultraProcessed,
      _ => ProcessingFoodType.unknown
    };
  }

  int _processingFoodToJson() {
    return switch (processingFoodType) {
      ProcessingFoodType.withoutOrMinimumProcessed => 1,
      ProcessingFoodType.processedCulinaryIngs => 2,
      ProcessingFoodType.processed => 3,
      ProcessingFoodType.ultraProcessed => 4,
      ProcessingFoodType.unknown => -1,
    };
  }

  static ProductNutrients? _nutrientLevelsFromJson(
    Map<String, dynamic>? nutrientLevels,
  ) {
    if (nutrientLevels == null) return null;

    return ProductNutrientsModel.fromJson(nutrientLevels);
  }
}
