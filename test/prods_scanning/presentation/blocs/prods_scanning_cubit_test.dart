import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_final_project_testing_openfoodfacts/core/failures/failure.dart';
import 'package:flutter_final_project_testing_openfoodfacts/prods_scanning/domain/entities/product.dart';
import 'package:flutter_final_project_testing_openfoodfacts/prods_scanning/domain/entities/product_nutrients.dart';
import 'package:flutter_final_project_testing_openfoodfacts/prods_scanning/domain/usecases/get_product_details.dart';
import 'package:flutter_final_project_testing_openfoodfacts/prods_scanning/domain/usecases/scan_and_get_product_details.dart';
import 'package:flutter_final_project_testing_openfoodfacts/prods_scanning/presentation/blocs/prods_scanning_cubit.dart';
import 'package:flutter_final_project_testing_openfoodfacts/prods_scanning/presentation/blocs/prods_scanning_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetProductDetails extends Mock implements GetProductDetails {}

class MockScanAndGetProductDetails extends Mock
    implements ScanAndGetProductDetails {}

void main() {
  late MockGetProductDetails mockGetProductDetails;
  late MockScanAndGetProductDetails mockScanAndGetProductDetails;

  setUp(() {
    mockGetProductDetails = MockGetProductDetails();
    mockScanAndGetProductDetails = MockScanAndGetProductDetails();
  });

  final product = Product(
    1,
    "Nutella",
    "E",
    "https://www.domain.com",
    "048938629",
    ProcessingFoodType.processed,
    ProductNutrients(
      ProcessingProductNutrientLevel.low,
      ProcessingProductNutrientLevel.low,
      ProcessingProductNutrientLevel.low,
      ProcessingProductNutrientLevel.low,
    ),
  );

  final barcode = "0123456789";

  blocTest<ProdsScanningCubit, ProdsScanningState>(
    "should return ProdsScanningInitial state as initial state",
    build: () => ProdsScanningCubit(
      mockGetProductDetails,
      mockScanAndGetProductDetails,
    ),
    verify: (cubit) => expect(cubit.state, isA<ProdsScanningInitial>()),
  );

  group("GetProductDetails usecase", () {
    blocTest<ProdsScanningCubit, ProdsScanningState>(
      "should emmit Loading and Loaded states on getProductDetails() successful request",
      build: () {
        when(() => mockGetProductDetails(barcode))
            .thenAnswer((_) async => Right(product));
        return ProdsScanningCubit(
          mockGetProductDetails,
          mockScanAndGetProductDetails,
        );
      },
      act: (cubit) => cubit.getProductDetails(barcode),
      expect: () => [
        ProdsScanningLoading(),
        ProdsScanningLoaded(product),
      ],
    );

    blocTest<ProdsScanningCubit, ProdsScanningState>(
      "should emmit Loading and Error states on getProductDetails() error request",
      build: () {
        when(() => mockGetProductDetails(barcode))
            .thenAnswer((_) async => Left(ServerFailure()));
        return ProdsScanningCubit(
          mockGetProductDetails,
          mockScanAndGetProductDetails,
        );
      },
      act: (cubit) => cubit.getProductDetails(barcode),
      expect: () => [
        ProdsScanningLoading(),
        ProdsScanningError(),
      ],
    );
  });

  group("ScanAndGetProductDetails usecase", () {
    blocTest<ProdsScanningCubit, ProdsScanningState>(
      "should emmit Loading and Loaded states on scanAndGetProductDetails() successful request",
      build: () {
        when(() => mockScanAndGetProductDetails())
            .thenAnswer((_) async => Right(product));
        return ProdsScanningCubit(
          mockGetProductDetails,
          mockScanAndGetProductDetails,
        );
      },
      act: (cubit) => cubit.scanAndGetProductDetails(),
      expect: () => [
        ProdsScanningLoading(),
        ProdsScanningLoaded(product),
      ],
    );

    blocTest<ProdsScanningCubit, ProdsScanningState>(
      "should emmit Loading and UserCancelled states on scanAndGetProductDetails()",
      build: () {
        when(() => mockScanAndGetProductDetails())
            .thenAnswer((_) async => Left(ScanCancelledFailure()));
        return ProdsScanningCubit(
          mockGetProductDetails,
          mockScanAndGetProductDetails,
        );
      },
      act: (cubit) => cubit.scanAndGetProductDetails(),
      expect: () => [
        ProdsScanningLoading(),
        ProdsScanningScanCancelled(),
      ],
    );

    blocTest<ProdsScanningCubit, ProdsScanningState>(
      "should emmit Loading and Error states on scanAndGetProductDetails()",
      build: () {
        when(() => mockScanAndGetProductDetails())
            .thenAnswer((_) async => Left(ServerFailure()));
        return ProdsScanningCubit(
          mockGetProductDetails,
          mockScanAndGetProductDetails,
        );
      },
      act: (cubit) => cubit.scanAndGetProductDetails(),
      expect: () => [
        ProdsScanningLoading(),
        ProdsScanningError(),
      ],
    );
  });
}
