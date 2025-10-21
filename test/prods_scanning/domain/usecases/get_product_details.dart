import 'package:dartz/dartz.dart';
import 'package:flutter_final_project_testing_openfoodfacts/core/failures/failure.dart';
import 'package:flutter_final_project_testing_openfoodfacts/prods_scanning/domain/entities/product.dart';
import 'package:flutter_final_project_testing_openfoodfacts/prods_scanning/domain/entities/product_nutrients.dart';
import 'package:flutter_final_project_testing_openfoodfacts/prods_scanning/domain/repositories/prods_scanning_repository.dart';
import 'package:flutter_final_project_testing_openfoodfacts/prods_scanning/domain/usecases/get_product_details.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockProdsScanningRepository extends Mock
    implements ProdsScanningRepository {}

void main() {
  late MockProdsScanningRepository mockProdsScanningRepository;
  late GetProductDetails useCase;

  setUp(() {
    mockProdsScanningRepository = MockProdsScanningRepository();
    useCase = GetProductDetails(mockProdsScanningRepository);
  });

  test("should return a Product instance if successful", () async {
    // Arrange
    const barCode = "897987987";
    final product = Product(
      1,
      "Nocilla",
      "A",
      "https://domain.com",
      barCode,
      ProcessingFoodType.processed,
      ProductNutrients(
        ProcessingProductNutrientLevel.high,
        ProcessingProductNutrientLevel.moderate,
        ProcessingProductNutrientLevel.moderate,
        ProcessingProductNutrientLevel.low,
      ),
    );

    when(() => mockProdsScanningRepository.getProductDetails(barCode))
        .thenAnswer(
      (_) async => Right(product),
    );

    // Act
    final productDetails = await useCase(barCode);

    // Assert
    verify(() => mockProdsScanningRepository.getProductDetails(barCode))
        .called(1);
    expect(productDetails, Right(product));
  });

  test("should return a Failure instance", () async {
    // Arrange
    const barCode = "897987987";
    when(() => mockProdsScanningRepository.getProductDetails(barCode))
        .thenAnswer(
      (_) async => Left(ServerFailure()),
    );

    // Act
    final productDetails = await useCase(barCode);

    // Assert
    verify(() => mockProdsScanningRepository.getProductDetails(barCode))
        .called(1);
    expect(productDetails, isA<Left>());

    productDetails.fold(
      (l) => expect(l, isA<ServerFailure>()),
      (r) => fail("Right either found"),
    );
  });
}
