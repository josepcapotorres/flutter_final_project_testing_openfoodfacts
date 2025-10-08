import '../../domain/entities/product_nutrients.dart';

class ProductNutrientsModel extends ProductNutrients {
  const ProductNutrientsModel(
    super.fat,
    super.saturatedFat,
    super.sugars,
    super.salt,
  );

  factory ProductNutrientsModel.fromJson(Map<String, dynamic> json) {
    return ProductNutrientsModel(
      _levelFromJson(json["fat"]),
      _levelFromJson(json["saturated-fat"]),
      _levelFromJson(json["sugars"]),
      _levelFromJson(json["salt"]),
    );
  }

  static ProcessingProductNutrientLevel _levelFromJson(String? value) {
    return switch (value) {
      "low" => ProcessingProductNutrientLevel.low,
      "moderate" => ProcessingProductNutrientLevel.moderate,
      "high" => ProcessingProductNutrientLevel.high,
      _ => ProcessingProductNutrientLevel.unknown,
    };
  }

  String _levelToJson(ProcessingProductNutrientLevel level) {
    return switch (level) {
      ProcessingProductNutrientLevel.low => "low",
      ProcessingProductNutrientLevel.moderate => "moderate",
      ProcessingProductNutrientLevel.high => "high",
      ProcessingProductNutrientLevel.unknown => "-",
    };
  }

  Map<String, dynamic> toJson() {
    return {
      "fat": _levelToJson(fatLevel),
      "saturated-fat": _levelToJson(saturatedFatLevel),
      "sugars": _levelToJson(sugarsLevel),
      "salt": _levelToJson(saltLevel),
    };
  }
}
