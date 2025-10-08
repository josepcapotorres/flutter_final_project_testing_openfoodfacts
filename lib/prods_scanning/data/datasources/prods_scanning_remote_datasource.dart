import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../core/exceptions/exceptions.dart';
import '../../../core/network/network_info.dart';
import '../models/product_model.dart';

abstract class ProdsScanningRemoteDatasource {
  Future<ProductModel> fetchProductDetails(String barcode);
}

class ProdsScanningRemoteDatasourceImpl extends ProdsScanningRemoteDatasource {
  final http.Client httpClient;
  final NetworkInfo networkInfo;

  ProdsScanningRemoteDatasourceImpl(this.httpClient, this.networkInfo);

  @override
  Future<ProductModel> fetchProductDetails(String barcode) async {
    if (await networkInfo.isConnected) {
      final response = await httpClient.get(
        Uri.parse("https://world.openfoodfacts.net/api/v2/product/$barcode"),
      );

      final responseBody = jsonDecode(response.body) as Map<String, dynamic>;

      return ProductModel.fromJson(responseBody);
    } else {
      throw ServerException();
    }
  }
}
