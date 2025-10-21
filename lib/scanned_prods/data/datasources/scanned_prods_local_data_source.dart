import 'package:hive/hive.dart';

import '../../../core/format/deep_cast.dart';
import '../models/scanned_prod_model.dart';

abstract class ScannedProdsLocalDataSource {
  Future<List<ScannedProdModel>> getPreviousScannedProds();
}

class ScannedProdsLocalDataSourceImpl extends ScannedProdsLocalDataSource {
  final Box<dynamic> box;

  ScannedProdsLocalDataSourceImpl(this.box);

  @override
  Future<List<ScannedProdModel>> getPreviousScannedProds() async {
    return box.values
        .map((e) => ScannedProdModel.fromJson(deepCast(e)))
        .toList();
  }
}
