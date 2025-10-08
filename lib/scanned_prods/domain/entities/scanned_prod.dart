import 'package:equatable/equatable.dart';

class ScannedProd extends Equatable {
  final String barcode;
  final String productName;
  final String productImageUrl;
  final DateTime insertedAt;

  const ScannedProd(
    this.barcode,
    this.productName,
    this.productImageUrl,
    this.insertedAt,
  );

  @override
  List<Object?> get props => [
    barcode,
    productName,
    productImageUrl,
    insertedAt,
  ];
}
