import 'package:flutter_barcode_scanner_plus/flutter_barcode_scanner_plus.dart';

abstract class ProdsScanningBarcodeScannerDataSource {
  Future<String?> scanProduct();
}

class ProdsScanningBarcodeScannerDataSourceImpl
    extends ProdsScanningBarcodeScannerDataSource {
  @override
  Future<String?> scanProduct() async {
    final result = await FlutterBarcodeScanner.scanBarcode(
      "#ff6666",
      "Cancel",
      false,
      ScanMode.DEFAULT,
    );

    if (result == "-1") return null;

    return result;
  }
}
