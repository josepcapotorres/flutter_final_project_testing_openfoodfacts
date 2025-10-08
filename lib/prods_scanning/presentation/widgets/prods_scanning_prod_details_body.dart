import 'package:flutter/material.dart';

import '../../domain/entities/product.dart';

class ProdsScanningProdDetailsBody extends StatelessWidget {
  final Product loadedProduct;

  const ProdsScanningProdDetailsBody(this.loadedProduct, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(loadedProduct.productName ?? "-")),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 10,
          children: [
            if (loadedProduct.productImgUrl != null)
              Image.network(
                loadedProduct.productImgUrl!,
                errorBuilder: (_, __, ___) =>
                    Image.asset("assets/images/error.png"),
              )
            else
              Image.asset("assets/images/error.png"),
            Text(loadedProduct.productName ?? "-")
          ],
        ),
      ),
    );
  }
}
