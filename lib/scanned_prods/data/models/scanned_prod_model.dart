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
      json["code"],
      json["product"]["product_name"],
      json["selected_images"]?["front"]["small"]["en"] ?? "-",
      json.containsKey("inserted_at")
          ? DateTime.parse(json["inserted_at"] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "code": barcode,
      "product": {"product_name": productName},
      "selected_images": {
        "front": {
          "small": {"en": productImageUrl},
        }
      },
      "inserted_at": insertedAt.toIso8601String(),
    };
  }
}
