import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_final_project_testing_openfoodfacts/prods_scanning/domain/entities/product.dart';
import 'package:flutter_final_project_testing_openfoodfacts/prods_scanning/domain/entities/product_nutrients.dart';
import 'package:flutter_final_project_testing_openfoodfacts/prods_scanning/presentation/blocs/prods_scanning_cubit.dart';
import 'package:flutter_final_project_testing_openfoodfacts/prods_scanning/presentation/blocs/prods_scanning_state.dart';
import 'package:flutter_final_project_testing_openfoodfacts/prods_scanning/presentation/pages/prods_scanning_prod_details_page.dart';
import 'package:flutter_final_project_testing_openfoodfacts/prods_scanning/presentation/widgets/prods_scanning_prod_details_body.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockProdsScanningCubit extends MockCubit<ProdsScanningState>
    implements ProdsScanningCubit {}

void main() {
  late MockProdsScanningCubit mockProdsScanningCubit;

  setUp(() {
    mockProdsScanningCubit = MockProdsScanningCubit();
  });

  final product = Product(
    "Nutella",
    "E",
    "https://images.openfoodfacts.net/images/products/301/762/401/0701/front_en.54.400.jpg",
    "048938629",
    ProcessingFoodType.processed,
    ProductNutrients(
      ProcessingProductNutrientLevel.low,
      ProcessingProductNutrientLevel.low,
      ProcessingProductNutrientLevel.low,
      ProcessingProductNutrientLevel.low,
    ),
  );

  testWidgets("by default, Loaded state is not Loaded", (tester) async {
    // arrange
    when(() => mockProdsScanningCubit.state).thenReturn(ProdsScanningInitial());

    // act
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<ProdsScanningCubit>.value(
          value: mockProdsScanningCubit,
          child: ProdsScanningProdDetailsPageContent(),
        ),
      ),
    );

    // assert
    expect(find.text("Producto no cargado"), findsOneWidget);
    expect(find.byType(ProdsScanningProdDetailsBody), findsNothing);
  });

  testWidgets("should be loaded the 'Loaded' state", (tester) async {
    // arrange
    when(() => mockProdsScanningCubit.state)
        .thenReturn(ProdsScanningLoaded(product));

    // act
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<ProdsScanningCubit>.value(
          value: mockProdsScanningCubit,
          child: ProdsScanningProdDetailsPageContent(),
        ),
      ),
    );

    await tester.pump();

    // assert
    expect(find.text("Producto no cargado"), findsNothing);
    expect(find.byType(ProdsScanningProdDetailsBody), findsOneWidget);
  });
}
