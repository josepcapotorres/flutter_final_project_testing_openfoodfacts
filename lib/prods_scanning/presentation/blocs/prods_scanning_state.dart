import 'package:equatable/equatable.dart';

import '../../domain/entities/product.dart';

sealed class ProdsScanningState extends Equatable {}

class ProdsScanningInitial extends ProdsScanningState {
  @override
  List<Object?> get props => [];
}

class ProdsScanningLoading extends ProdsScanningState {
  @override
  List<Object?> get props => [];
}

class ProdsScanningLoaded extends ProdsScanningState {
  final Product product;

  ProdsScanningLoaded(this.product);

  @override
  List<Object?> get props => [];
}

class ProdsScanningError extends ProdsScanningState {
  @override
  List<Object?> get props => [];
}

class ProdNotFound extends ProdsScanningState {
  @override
  List<Object?> get props => [];
}

class ProdsScanningScanCancelled extends ProdsScanningState {
  @override
  List<Object?> get props => [];
}
