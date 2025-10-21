import 'package:flutter/material.dart';

import '../../../prods_scanning/presentation/pages/prods_scanning_prod_details_page.dart';
import '../../domain/entities/scanned_prod.dart';

class ScannedProdsGridItem extends StatelessWidget {
  final ScannedProd product;

  const ScannedProdsGridItem(this.product, {super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(
        context,
        ProdsScanningProdDetailsPage.route,
        arguments: product.barcode,
      ),
      child: Card(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            FadeInImage(
              placeholder: AssetImage("assets/images/loading.gif"),
              image: NetworkImage(product.productImageUrl),
              imageErrorBuilder: (_, __, ___) =>
                  Image.asset("assets/images/error.png"),
            ),
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent, // Parte superior sin oscurecer
                      Colors.black54, // Parte inferior más oscura
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(product.productName,
                  style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
