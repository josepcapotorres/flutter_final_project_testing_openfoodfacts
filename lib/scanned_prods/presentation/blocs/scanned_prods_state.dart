import '../../domain/entities/scanned_prod.dart';

sealed class ScannedProdsState {}

class ScannedProdsInitial extends ScannedProdsState {}

class ScannedProdsLoading extends ScannedProdsState {}

class ScannedProdsEmpty extends ScannedProdsState {}

class ScannedProdsLoaded extends ScannedProdsState {
  final List<ScannedProd> products;

  ScannedProdsLoaded(this.products);
}
