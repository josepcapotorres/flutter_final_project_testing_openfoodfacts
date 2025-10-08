import 'package:flutter/material.dart';

import '../../domain/entities/scanned_prod.dart';
import 'scanned_prods_grid_item.dart';

class ScannedProdsGrid extends StatelessWidget {
  final List<ScannedProd> products;

  const ScannedProdsGrid(this.products, {super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemBuilder: (_, i) => ScannedProdsGridItem(products[i]),
      itemCount: products.length,
    );
  }
}
