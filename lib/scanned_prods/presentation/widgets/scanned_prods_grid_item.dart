import 'package:flutter/material.dart';

import '../../domain/entities/scanned_prod.dart';

class ScannedProdsGridItem extends StatelessWidget {
  final ScannedProd product;

  const ScannedProdsGridItem(this.product, {super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FadeInImage(
          placeholder: AssetImage("assets/images/loading.gif"),
          image: NetworkImage(product.productImageUrl),
          imageErrorBuilder: (_, __, ___) =>
              Image.asset("assets/images/error.png"),
        ),
      ],
    );
  }
}
