import 'package:equatable/equatable.dart';

import 'product_nutrients.dart';

class Product extends Equatable {
  final int status;
  final String? productName;
  final String? nutriscoreScore;
  final String? productImgUrl;
  final String barcode;
  final ProcessingFoodType processingFoodType;
  final ProductNutrients? productNutrient;

  const Product(
    this.status,
    this.productName,
    this.nutriscoreScore,
    this.productImgUrl,
    this.barcode,
    this.processingFoodType,
    this.productNutrient,
  );

  @override
  List<Object?> get props => [
        status,
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
