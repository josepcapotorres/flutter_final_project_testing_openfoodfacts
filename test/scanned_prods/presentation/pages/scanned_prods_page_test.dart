import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_final_project_testing_openfoodfacts/prods_scanning/domain/entities/product.dart';
import 'package:flutter_final_project_testing_openfoodfacts/prods_scanning/domain/entities/product_nutrients.dart';
import 'package:flutter_final_project_testing_openfoodfacts/prods_scanning/domain/usecases/get_product_details.dart';
import 'package:flutter_final_project_testing_openfoodfacts/prods_scanning/domain/usecases/scan_and_get_product_details.dart';
import 'package:flutter_final_project_testing_openfoodfacts/prods_scanning/presentation/blocs/prods_scanning_cubit.dart';
import 'package:flutter_final_project_testing_openfoodfacts/prods_scanning/presentation/blocs/prods_scanning_state.dart';
import 'package:flutter_final_project_testing_openfoodfacts/prods_scanning/presentation/pages/prods_scanning_prod_details_page.dart';
import 'package:flutter_final_project_testing_openfoodfacts/scanned_prods/domain/entities/scanned_prod.dart';
import 'package:flutter_final_project_testing_openfoodfacts/scanned_prods/domain/usecases/get_previous_scanned_prods.dart';
import 'package:flutter_final_project_testing_openfoodfacts/scanned_prods/presentation/blocs/scanned_prods_cubit.dart';
import 'package:flutter_final_project_testing_openfoodfacts/scanned_prods/presentation/pages/scanned_prods_page.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetPreviousScannedProds extends Mock
    implements GetPreviousScannedProds {}

class MockGetProductDetails extends Mock implements GetProductDetails {}

class MockScanAndGetProductDetails extends Mock
    implements ScanAndGetProductDetails {}

class MockProdsScanningCubit extends MockCubit<ProdsScanningState>
    implements ProdsScanningCubit {}

void main() async {
  late MockGetPreviousScannedProds mockGetPreviousScannedProds;
  late MockGetProductDetails mockGetProductDetails;
  late MockScanAndGetProductDetails mockScanAndGetProductDetails;
  late MockProdsScanningCubit mockProdsScanningCubit;

  setUp(() {
    mockGetPreviousScannedProds = MockGetPreviousScannedProds();
    mockGetProductDetails = MockGetProductDetails();
    mockScanAndGetProductDetails = MockScanAndGetProductDetails();
    mockProdsScanningCubit = MockProdsScanningCubit();
  });

  testWidgets("ensure we load the widget ScannedProdsPage", (tester) async {
    // arrange
    when(() => mockGetPreviousScannedProds()).thenAnswer((_) async => []);

    final scannedProdsCubit = ScannedProdsCubit(mockGetPreviousScannedProds);
    final detailsProductCubit = ProdsScanningCubit(
      mockGetProductDetails,
      mockScanAndGetProductDetails,
    );

    // act
    await tester.pumpWidget(
      MaterialApp(
        home: MultiBlocProvider(
          providers: [
            BlocProvider.value(value: scannedProdsCubit),
            BlocProvider.value(value: detailsProductCubit)
          ],
          child: const ScannedProdsContent(),
        ),
      ),
    );

    // assert
    expect(find.text("Productos escaneados"), findsOneWidget);
  });

  testWidgets(
      "ensure we load the CircularProgressIndicator widget while waiting for data",
      (tester) async {
    // arrange
    when(() => mockGetPreviousScannedProds()).thenAnswer((_) async => []);

    final scannedProdsCubit = ScannedProdsCubit(mockGetPreviousScannedProds);
    final detailsProductCubit = ProdsScanningCubit(
      mockGetProductDetails,
      mockScanAndGetProductDetails,
    );

    // act
    await tester.pumpWidget(
      MaterialApp(
        home: MultiBlocProvider(
          providers: [
            BlocProvider.value(value: scannedProdsCubit),
            BlocProvider.value(value: detailsProductCubit)
          ],
          child: const ScannedProdsContent(),
        ),
      ),
    );

    // assert
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets("ensure we load the Grid widget when data is not empty",
      (tester) async {
    // arrange
    when(() => mockGetPreviousScannedProds()).thenAnswer(
      (_) async => [
        ScannedProd(
            "048938629", "Nutella", "https://domain.com", DateTime.now()),
        ScannedProd(
            "048938629", "Nutella", "https://domain.com", DateTime.now()),
      ],
    );

    final scannedProdsCubit = ScannedProdsCubit(mockGetPreviousScannedProds);
    final detailsProductCubit = ProdsScanningCubit(
      mockGetProductDetails,
      mockScanAndGetProductDetails,
    );

    // act
    await tester.pumpWidget(
      MaterialApp(
        home: MultiBlocProvider(
          providers: [
            BlocProvider.value(value: scannedProdsCubit),
            BlocProvider.value(value: detailsProductCubit)
          ],
          child: const ScannedProdsContent(),
        ),
      ),
    );

    await tester.pump();

    // assert
    expect(find.byType(GridView), findsOneWidget);
  });

  testWidgets("ensure we load the Grid widget when data is empty",
      (tester) async {
    // arrange
    when(() => mockGetPreviousScannedProds()).thenAnswer(
      (_) async => [],
    );

    final scannedProdsCubit = ScannedProdsCubit(mockGetPreviousScannedProds);
    final detailsProductCubit = ProdsScanningCubit(
      mockGetProductDetails,
      mockScanAndGetProductDetails,
    );

    // act
    await tester.pumpWidget(
      MaterialApp(
        home: MultiBlocProvider(
          providers: [
            BlocProvider.value(value: scannedProdsCubit),
            BlocProvider.value(value: detailsProductCubit)
          ],
          child: const ScannedProdsContent(),
        ),
      ),
    );

    await tester.pump();

    // assert
    expect(find.text("No hay elementos escaneados aún"), findsOneWidget);
  });

  group("ProdsScanningCubit", () {
    void arrangeErrorStatesStubs(ProdsScanningState state) {
      whenListen(
        mockProdsScanningCubit,
        Stream.fromIterable([state]),
        initialState: ProdsScanningLoading(),
      );

      when(() => mockGetPreviousScannedProds()).thenAnswer((_) async => []);
    }

    Widget getScannedProdsContentWidget() {
      return MultiBlocProvider(
        providers: [
          BlocProvider<ProdsScanningCubit>.value(
            value: mockProdsScanningCubit,
          ),
          BlocProvider<ScannedProdsCubit>.value(
            value: ScannedProdsCubit(mockGetPreviousScannedProds),
          ),
        ],
        child: const ScannedProdsContent(),
      );
    }

    testWidgets(
      "should show a message when ProdsScanningScanCancelled state is loaded",
      (tester) async {
        // arrange
        arrangeErrorStatesStubs(ProdsScanningScanCancelled());

        // act
        await tester.pumpWidget(
          MaterialApp(
            home: getScannedProdsContentWidget(),
          ),
        );

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
        await tester.pumpWidget(
          MaterialApp(
            home: getScannedProdsContentWidget(),
          ),
        );

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
            home: getScannedProdsContentWidget(),
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
