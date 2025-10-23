import 'package:flutter/material.dart';

import 'environment.dart';
import 'injection_container.dart' as di;
import 'prods_scanning/presentation/pages/prods_scanning_prod_details_page.dart';
import 'scanned_prods/presentation/pages/scanned_prods_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await di.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Environment.appName,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      initialRoute: "/",
      routes: {
        "/": (_) => ScannedProdsPage(),
        ProdsScanningProdDetailsPage.route: (_) =>
            ProdsScanningProdDetailsPage(),
      },
    );
  }
}
