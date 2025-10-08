import 'dart:convert';

import 'package:flutter_final_project_testing_openfoodfacts/core/exceptions/exceptions.dart';
import 'package:flutter_final_project_testing_openfoodfacts/core/network/network_info.dart';
import 'package:flutter_final_project_testing_openfoodfacts/prods_scanning/data/datasources/prods_scanning_remote_datasource.dart';
import 'package:flutter_final_project_testing_openfoodfacts/prods_scanning/data/models/product_model.dart';
import 'package:flutter_final_project_testing_openfoodfacts/prods_scanning/data/models/product_nutrients_model.dart';
import 'package:flutter_final_project_testing_openfoodfacts/prods_scanning/domain/entities/product.dart';
import 'package:flutter_final_project_testing_openfoodfacts/prods_scanning/domain/entities/product_nutrients.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';

class MockNetworkInfo extends Mock implements NetworkInfo {}

class MockHttpClient extends Mock implements http.Client {}

void main() {
  late MockNetworkInfo mockNetworkInfo;
  late MockHttpClient mockHttpClient;
  late ProdsScanningRemoteDatasourceImpl sut;

  setUp(() {
    mockNetworkInfo = MockNetworkInfo();
    mockHttpClient = MockHttpClient();
    sut = ProdsScanningRemoteDatasourceImpl(
      mockHttpClient,
      mockNetworkInfo,
    );
  });

  setUpAll(() {
    registerFallbackValue(Uri());
  });

  final productModel = ProductModel(
    "Nutella",
    "E",
    "https://www.domain.com",
    "048938629",
    ProcessingFoodType.processed,
    ProductNutrientsModel(
      ProcessingProductNutrientLevel.low,
      ProcessingProductNutrientLevel.low,
      ProcessingProductNutrientLevel.low,
      ProcessingProductNutrientLevel.low,
    ),
  );

  final barcode = "0123456789";

  group("isOnline", () {
    test("should call fetchProductDetails and retrieve the data properly",
        () async {
      // Arrange
      when(() => mockNetworkInfo.isConnected)
          .thenAnswer((_) async => Future.value(true));
      when(() => mockHttpClient.get(any())).thenAnswer(
        (_) async => http.Response(jsonEncode(productModel.toJson()), 200),
      );

      // Act
      final productDetails = await sut.fetchProductDetails(barcode);

      // Assert
      verify(() => mockHttpClient.get(any())).called(1);
      expect(productDetails, productModel);
    });
  });

  group("isOffline", () {
    test("should call fetchProductDetails and throw a ServerException",
        () async {
      // Arrange
      when(() => mockNetworkInfo.isConnected)
          .thenAnswer((_) async => Future.value(false));
      when(() => mockHttpClient.get(any())).thenAnswer(
        (_) async => http.Response('', 500),
      );

      // Assert
      expect(() => sut.fetchProductDetails(barcode),
          throwsA(isA<ServerException>()));
    });
  });
}
