import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_final_project_testing_openfoodfacts/prods_scanning/domain/entities/product.dart';
import 'package:flutter_final_project_testing_openfoodfacts/prods_scanning/domain/entities/product_nutrients.dart';
import 'package:flutter_final_project_testing_openfoodfacts/prods_scanning/presentation/blocs/prods_scanning_cubit.dart';
import 'package:flutter_final_project_testing_openfoodfacts/prods_scanning/presentation/blocs/prods_scanning_state.dart';
import 'package:flutter_final_project_testing_openfoodfacts/prods_scanning/presentation/pages/prods_scanning_prod_details_page.dart';
import 'package:flutter_final_project_testing_openfoodfacts/scanned_prods/domain/entities/scanned_prod.dart';
import 'package:flutter_final_project_testing_openfoodfacts/scanned_prods/presentation/blocs/scanned_prods_cubit.dart';
import 'package:flutter_final_project_testing_openfoodfacts/scanned_prods/presentation/blocs/scanned_prods_state.dart';
import 'package:flutter_final_project_testing_openfoodfacts/scanned_prods/presentation/pages/scanned_prods_page.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockProdsScanningCubit extends MockCubit<ProdsScanningState>
    implements ProdsScanningCubit {}

class MockScannedProdsCubit extends MockCubit<ScannedProdsState>
    implements ScannedProdsCubit {}

void main() async {
  late MockProdsScanningCubit mockProdsScanningCubit;
  late MockScannedProdsCubit mockScannedProdsCubit;

  setUp(() {
    mockProdsScanningCubit = MockProdsScanningCubit();
    mockScannedProdsCubit = MockScannedProdsCubit();
  });

  Future<void> pumpWidget(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: MultiBlocProvider(
          providers: [
            BlocProvider<ScannedProdsCubit>.value(value: mockScannedProdsCubit),
            BlocProvider<ProdsScanningCubit>.value(
              value: mockProdsScanningCubit,
            )
          ],
          child: const ScannedProdsContent(),
        ),
      ),
    );
  }

  testWidgets("ensure we load the widget ScannedProdsPage", (tester) async {
    // arrange
    when(() => mockScannedProdsCubit.state).thenReturn(ScannedProdsInitial());
    when(() => mockProdsScanningCubit.state).thenReturn(ProdsScanningInitial());

    // act
    await pumpWidget(tester);

    // assert
    expect(find.text("Productos escaneados"), findsOneWidget);
  });

  testWidgets(
      "ensure we load the CircularProgressIndicator widget while waiting for data",
      (tester) async {
    // arrange
    when(() => mockScannedProdsCubit.state).thenReturn(ScannedProdsLoading());
    when(() => mockProdsScanningCubit.state).thenReturn(ProdsScanningInitial());

    // act
    await pumpWidget(tester);

    // assert
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets("ensure we load the Grid widget when data is not empty",
      (tester) async {
    // arrange
    final products = [
      ScannedProd("048938629", "Nutella", "https://domain.com", DateTime.now()),
      ScannedProd("048938629", "Nutella", "https://domain.com", DateTime.now()),
    ];

    when(() => mockScannedProdsCubit.state)
        .thenReturn(ScannedProdsLoaded(products));
    when(() => mockProdsScanningCubit.state).thenReturn(ProdsScanningInitial());

    // act
    await pumpWidget(tester);

    await tester.pump();

    // assert
    expect(find.byType(GridView), findsOneWidget);
  });

  testWidgets("ensure we load the Grid widget when data is empty",
      (tester) async {
    // arrange
    when(() => mockScannedProdsCubit.state).thenReturn(ScannedProdsEmpty());
    when(() => mockProdsScanningCubit.state).thenReturn(ProdsScanningInitial());

    // act
    await pumpWidget(tester);

    await tester.pump();

    // assert
    expect(find.text("No hay elementos escaneados aún"), findsOneWidget);
  });

  group("ProdsScanningCubit", () {
    void arrangeErrorStatesStubs(ProdsScanningState state) {
      when(() => mockProdsScanningCubit.state).thenReturn(state);
      when(() => mockScannedProdsCubit.state).thenReturn(ScannedProdsInitial());

      whenListen(
        mockProdsScanningCubit,
        Stream.fromIterable([state]),
        initialState: ProdsScanningLoading(),
      );
    }

    testWidgets(
      "should show a message when ProdsScanningScanCancelled state is loaded",
      (tester) async {
        // arrange
        arrangeErrorStatesStubs(ProdsScanningScanCancelled());

        // act
        await pumpWidget(tester);

        mockProdsScanningCubit.emit(ProdsScanningScanCancelled());

        await tester.pump();
        await tester.pump();

        // assert
        expect(find.text("Escaneo cancelado por el usuario"), findsOneWidget);
      },
    );

    testWidgets(
      "should show a message when ProdsScanningError state is loaded",
      (tester) async {
        // arrange
        arrangeErrorStatesStubs(ProdsScanningError());

        // act
        await pumpWidget(tester);

        mockProdsScanningCubit.emit(ProdsScanningError());

        await tester.pump();
        await tester.pump();

        // assert
        expect(
          find.text("Error al obtener los datos del producto"),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      "should navigate to the product detail page when ProdsScanningLoaded state is loaded",
      (tester) async {
        // arrange
        final product = Product(
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

        arrangeErrorStatesStubs(ProdsScanningLoaded(product));

        // act
        await tester.pumpWidget(
          MaterialApp(
            routes: {
              ProdsScanningProdDetailsPage.route: (_) =>
                  BlocProvider<ProdsScanningCubit>.value(
                    value: mockProdsScanningCubit,
                    child: ProdsScanningProdDetailsPageContent(),
                  ),
            },
            home: MultiBlocProvider(
              providers: [
                BlocProvider<ScannedProdsCubit>.value(
                    value: mockScannedProdsCubit),
                BlocProvider<ProdsScanningCubit>.value(
                    value: mockProdsScanningCubit)
              ],
              child: const ScannedProdsContent(),
            ),
          ),
        );

        mockProdsScanningCubit.emit(ProdsScanningLoaded(product));

        await tester.pumpAndSettle();

        // assert
        expect(find.text(product.productName!), findsOneWidget);
      },
    );
  });
}
