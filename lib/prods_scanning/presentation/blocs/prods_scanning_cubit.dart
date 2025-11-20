import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_final_project_testing_openfoodfacts/core/failures/failure.dart';

import '../../domain/usecases/get_product_details.dart';
import '../../domain/usecases/scan_and_get_product_details.dart';
import 'prods_scanning_state.dart';

class ProdsScanningCubit extends Cubit<ProdsScanningState> {
  final GetProductDetails _getProductDetailsUseCase;
  final ScanAndGetProductDetails _scanAndGetProductDetailsUseCase;

  ProdsScanningCubit(
    this._getProductDetailsUseCase,
    this._scanAndGetProductDetailsUseCase,
  ) : super(ProdsScanningInitial());

  void getProductDetails(String barcode) async {
    emit(ProdsScanningLoading());

    await Future(() {});

    final result = await _getProductDetailsUseCase(barcode);

    result.fold(
      (l) {
        if (l is ProductNotFoundFailure) {
          emit(ProdNotFound());
        } else {
          emit(ProdsScanningError());
        }
      },
      (r) => emit(ProdsScanningLoaded(r)),
    );
  }

  void scanAndGetProductDetails() async {
    emit(ProdsScanningLoading());

    final result = await _scanAndGetProductDetailsUseCase();

    result.fold(
      (l) {
        if (l is ScanCancelledFailure) {
          emit(ProdsScanningScanCancelled());
        } else if (l is ProductNotFoundFailure) {
          emit(ProdNotFound());
        } else {
          emit(ProdsScanningError());
        }
      },
      (r) => emit(ProdsScanningLoaded(r)),
    );
  }
}
