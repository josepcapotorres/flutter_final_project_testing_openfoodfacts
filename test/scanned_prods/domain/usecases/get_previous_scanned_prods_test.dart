import 'package:flutter_final_project_testing_openfoodfacts/scanned_prods/domain/entities/scanned_prod.dart';
import 'package:flutter_final_project_testing_openfoodfacts/scanned_prods/domain/repositories/scanned_prods_repository.dart';
import 'package:flutter_final_project_testing_openfoodfacts/scanned_prods/domain/usecases/get_previous_scanned_prods.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockScannedProdsRepository extends Mock
    implements ScannedProdsRepository {}

void main() {
  late GetPreviousScannedProds useCase;
  late MockScannedProdsRepository mockScannedProdsRepository;

  setUp(() {
    mockScannedProdsRepository = MockScannedProdsRepository();
    useCase = GetPreviousScannedProds(mockScannedProdsRepository);
  });

  test("should return a list of products", () async {
    final products = [
      ScannedProd("048938629", "Nutella", "https://domain.com", DateTime.now()),
      ScannedProd("048938629", "Nutella", "https://domain.com", DateTime.now()),
      ScannedProd("048938629", "Nutella", "https://domain.com", DateTime.now()),
    ];

    _expectUseCaseToReturnProducts(
      mockScannedProdsRepository,
      products,
      useCase,
    );
  });

  test("should return an empty list of products", () async {
    final products = <ScannedProd>[];

    _expectUseCaseToReturnProducts(
      mockScannedProdsRepository,
      products,
      useCase,
    );
  });

  test("should return a sorted list of products by inserted date", () async {
    // Arrange
    final originalProducts = [
      ScannedProd(
          "048938629", "Nutella", "https://domain.com", DateTime(2025, 2, 10)),
      ScannedProd(
          "048938629", "Nutella", "https://domain.com", DateTime(2025, 1, 10)),
      ScannedProd(
          "048938629", "Nutella", "https://domain.com", DateTime(2025, 3, 10)),
    ];

    final products = [...originalProducts];

    // Act
    await _expectUseCaseToReturnProducts(
      mockScannedProdsRepository,
      products,
      useCase,
    );

    // Assert
    expect(
      products,
      [originalProducts[2], originalProducts[0], originalProducts[1]],
    );
  });
}

Future<void> _expectUseCaseToReturnProducts(
  MockScannedProdsRepository mockScannedProdsRepository,
  List<ScannedProd> products,
  GetPreviousScannedProds useCase,
) async {
  // Arrange
  when(
    () => mockScannedProdsRepository.getPreviousScannedProds(),
  ).thenAnswer((_) async => products);

  // Act
  final result = await useCase();

  // Assert
  verify(
    () => mockScannedProdsRepository.getPreviousScannedProds(),
  ).called(1);

  expect(result, products);
  verifyNoMoreInteractions(mockScannedProdsRepository);
}
