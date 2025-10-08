import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_previous_scanned_prods.dart';
import 'scanned_prods_state.dart';

class ScannedProdsCubit extends Cubit<ScannedProdsState> {
  final GetPreviousScannedProds _getPreviousScannedProdsUseCase;

  ScannedProdsCubit(this._getPreviousScannedProdsUseCase)
      : super(ScannedProdsInitial());

  void getPreviousScannedProds() async {
    emit(ScannedProdsLoading());

    final products = await _getPreviousScannedProdsUseCase();

    if (products.isNotEmpty) {
      emit(ScannedProdsLoaded(products));
    } else {
      emit(ScannedProdsEmpty());
    }
  }
}
