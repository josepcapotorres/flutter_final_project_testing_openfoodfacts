import 'package:equatable/equatable.dart';

class ProductNutrients extends Equatable {
  final ProcessingProductNutrientLevel fatLevel;
  final ProcessingProductNutrientLevel saturatedFatLevel;
  final ProcessingProductNutrientLevel sugarsLevel;
  final ProcessingProductNutrientLevel saltLevel;

  const ProductNutrients(
    this.fatLevel,
    this.saturatedFatLevel,
    this.sugarsLevel,
    this.saltLevel,
  );

  @override
  List<Object?> get props => [
        fatLevel,
        saturatedFatLevel,
        sugarsLevel,
        saltLevel,
      ];
}

enum ProcessingProductNutrientLevel { low, moderate, high, unknown }
