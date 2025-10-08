import 'package:equatable/equatable.dart';

import 'product_nutrients.dart';

class Product extends Equatable {
  final String? productName;
  final String? nutriscoreScore;
  final String? productImgUrl;
  final String barcode;
  final ProcessingFoodType processingFoodType;
  final ProductNutrients? productNutrient;

  const Product(
    this.productName,
    this.nutriscoreScore,
    this.productImgUrl,
    this.barcode,
    this.processingFoodType,
    this.productNutrient,
  );

  @override
  List<Object?> get props => [
        productName,
        nutriscoreScore,
        productImgUrl,
        barcode,
        processingFoodType,
        productNutrient,
      ];
}

enum ProcessingFoodType {
  withoutOrMinimumProcessed,
  processedCulinaryIngs,
  processed,
  ultraProcessed,
  unknown,
}
