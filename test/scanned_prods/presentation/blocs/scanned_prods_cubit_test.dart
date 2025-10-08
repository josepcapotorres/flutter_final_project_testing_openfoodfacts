import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_final_project_testing_openfoodfacts/scanned_prods/data/models/scanned_prod_model.dart';
import 'package:flutter_final_project_testing_openfoodfacts/scanned_prods/domain/usecases/get_previous_scanned_prods.dart';
import 'package:flutter_final_project_testing_openfoodfacts/scanned_prods/presentation/blocs/scanned_prods_cubit.dart';
import 'package:flutter_final_project_testing_openfoodfacts/scanned_prods/presentation/blocs/scanned_prods_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetPreviousScannedProds extends Mock
    implements GetPreviousScannedProds {}

void main() {
  late MockGetPreviousScannedProds mockGetPreviousScannedProdsUseCase;

  setUp(() {
    mockGetPreviousScannedProdsUseCase = MockGetPreviousScannedProds();
  });

  blocTest<ScannedProdsCubit, ScannedProdsState>(
    "should return ...Initial as initial state",
    build: () => ScannedProdsCubit(mockGetPreviousScannedProdsUseCase),
    verify: (cubit) => expect(cubit.state, isA<ScannedProdsInitial>()),
  );

  blocTest<ScannedProdsCubit, ScannedProdsState>(
    "should return ...Loaded when a non empty list is returned",
    build: () {
      final products = [
        ScannedProdModel(
          "4802784957",
          "Cebolla encurtida",
          "https://domain.com",
          DateTime(2025, 08, 23),
        ),
        ScannedProdModel(
          "4802784957",
          "Cebolla encurtida",
          "https://domain.com",
          DateTime(2025, 07, 23),
        )
      ];

      when(() => mockGetPreviousScannedProdsUseCase()).thenAnswer(
        (_) async => products,
      );

      return ScannedProdsCubit(mockGetPreviousScannedProdsUseCase);
    },
    act: (cubit) => cubit.getPreviousScannedProds(),
    expect: () => [
      isA<ScannedProdsLoading>(),
      isA<ScannedProdsLoaded>(),
    ],
  );

  blocTest<ScannedProdsCubit, ScannedProdsState>(
    "should return ...Empty when an empty list is returned",
    build: () {
      when(() => mockGetPreviousScannedProdsUseCase()).thenAnswer(
        (_) async => [],
      );

      return ScannedProdsCubit(mockGetPreviousScannedProdsUseCase);
    },
    act: (cubit) => cubit.getPreviousScannedProds(),
    expect: () => [
      isA<ScannedProdsLoading>(),
      isA<ScannedProdsEmpty>(),
    ],
  );
}
