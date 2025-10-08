import 'package:hive/hive.dart';

import '../models/scanned_prod_model.dart';

abstract class ScannedProdsLocalDataSource {
  Future<List<ScannedProdModel>> getPreviousScannedProds();
}

class ScannedProdsLocalDataSourceImpl extends ScannedProdsLocalDataSource {
  final Box<Map<String, dynamic>> box;

  ScannedProdsLocalDataSourceImpl(this.box);

  @override
  Future<List<ScannedProdModel>> getPreviousScannedProds() async {
    return box.values.map((e) => ScannedProdModel.fromJson(e)).toList();
  }
}
