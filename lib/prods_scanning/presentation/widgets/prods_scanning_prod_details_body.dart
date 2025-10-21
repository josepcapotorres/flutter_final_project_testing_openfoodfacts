import 'package:flutter/material.dart';

import '../../domain/entities/product.dart';

class ProdsScanningProdDetailsBody extends StatelessWidget {
  final Product loadedProduct;

  const ProdsScanningProdDetailsBody(this.loadedProduct, {super.key});

  @override
  Widget build(BuildContext context) {
    final nutriscoreScore = loadedProduct.nutriscoreScore ?? "-";

    return SingleChildScrollView(
      child: Column(
        spacing: 10,
        children: [
          const SizedBox(
            width: double.infinity,
          ),
          if (loadedProduct.productImgUrl != null)
            Image.network(
              loadedProduct.productImgUrl!,
              errorBuilder: (_, __, ___) =>
                  Image.asset("assets/images/error.png"),
            )
          else
            Image.asset("assets/images/error.png"),
          Text(
            loadedProduct.productName ?? "-",
            style: Theme.of(context).textTheme.titleLarge,
          ),
          ListTile(
            title: Text("Puntuación de Nutriscore: asd asf asdf asdf asdf"),
            subtitle: _NutriScoreValue(loadedProduct.nutriscoreScore),
          ),
          ListTile(
            title: Text("Tipo de procesado: "),
            subtitle: _ProcessedType(loadedProduct.processingFoodType),
          ),
        ],
      ),
    );
  }
}

class _NutriScoreValue extends StatelessWidget {
  final String? score;

  const _NutriScoreValue(this.score);

  @override
  Widget build(BuildContext context) {
    return Text(
      score?.toUpperCase() ?? "-",
      style: TextStyle(
        fontSize: 22,
        color: _getNutriScoreColors(),
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Color _getNutriScoreColors() {
    return switch (score) {
      'a' => Color(0xFF00833D),
      'b' => Color(0xFF85BB2F),
      'c' => Color(0xFFFECB02),
      'd' => Color(0xFFEE8100),
      'e' => Color(0xFFE63E11),
      _ => Colors.black,
    };
  }
}

class _ProcessedType extends StatelessWidget {
  final ProcessingFoodType processingFoodType;

  const _ProcessedType(this.processingFoodType);

  @override
  Widget build(BuildContext context) {
    final strProcessingType = switch (processingFoodType) {
      ProcessingFoodType.withoutOrMinimumProcessed =>
        "Alimentos no procesados o mínimamente procesados",
      ProcessingFoodType.processedCulinaryIngs =>
        "Ingredientes culinarios procesados",
      ProcessingFoodType.processed => "Alimentos procesados",
      ProcessingFoodType.ultraProcessed => "Alimentos ultraprocesados",
      ProcessingFoodType.unknown => "Nova no calculado",
    };

    return Text(strProcessingType);
  }
}
