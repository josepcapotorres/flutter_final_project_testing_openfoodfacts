import '../../domain/entities/scanned_prod.dart';

class ScannedProdModel extends ScannedProd {
  const ScannedProdModel(
    super.barcode,
    super.productName,
    super.productImageUrl,
    super.insertedAt,
  );

  factory ScannedProdModel.fromJson(Map<String, dynamic> json) {
    return ScannedProdModel(
      json["barcode"],
      json["product_name"],
      json["product_img_url"],
      DateTime.parse(json["inserted_at"] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "barcode": barcode,
      "product_name": productName,
      "product_img_url": productImageUrl,
      "inserted_at": insertedAt.toIso8601String(),
    };
  }
}
