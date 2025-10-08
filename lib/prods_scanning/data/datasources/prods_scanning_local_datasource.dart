import 'package:hive/hive.dart';

import '../models/product_model.dart';

abstract class ProdsScanningLocalDatasource {
  Future<List<ProductModel>> getPreviousScannedProds();

  Future<ProductModel?> getScannedProd(String barcode);

  Future<void> cacheScannedProd(ProductModel product);
}

class ProdsScanningLocalDatasourceImpl extends ProdsScanningLocalDatasource {
  final Box<Map<String, dynamic>> _box;

  ProdsScanningLocalDatasourceImpl(this._box);

  @override
  Future<void> cacheScannedProd(ProductModel product) async {
    await _box.put(product.barcode, product.toJson());
  }

  @override
  Future<List<ProductModel>> getPreviousScannedProds() {
    return Future.value(
      _box.values.map((e) => ProductModel.fromJson(e)).toList(),
    );
  }

  @override
  Future<ProductModel?> getScannedProd(String barcode) async {
    final result = _box.get(barcode);

    if (result == null) return null;

    return Future.value(ProductModel.fromJson(result));
  }
}
