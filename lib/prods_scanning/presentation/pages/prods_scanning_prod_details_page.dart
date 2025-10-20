import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../injection_container.dart';
import '../blocs/prods_scanning_cubit.dart';
import '../blocs/prods_scanning_state.dart';
import '../widgets/prods_scanning_prod_details_body.dart';

class ProdsScanningProdDetailsPage extends StatelessWidget {
  static const route = "/product_details";

  const ProdsScanningProdDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProdsScanningCubit>(
      create: (_) => sl(),
      child: ProdsScanningProdDetailsPageContent(),
    );
  }
}

class ProdsScanningProdDetailsPageContent extends StatefulWidget {
  const ProdsScanningProdDetailsPageContent({super.key});

  @override
  State<ProdsScanningProdDetailsPageContent> createState() =>
      _ProdsScanningProdDetailsPageContentState();
}

class _ProdsScanningProdDetailsPageContentState
    extends State<ProdsScanningProdDetailsPageContent> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final barcode = ModalRoute.of(context)?.settings.arguments as String?;

      if (barcode != null) {
        context.read<ProdsScanningCubit>().getProductDetails(barcode);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocBuilder<ProdsScanningCubit, ProdsScanningState>(
        builder: (context, state) {
          return switch (state) {
            ProdsScanningInitial() => const SizedBox.shrink(),
            ProdsScanningLoading() => const Center(
                child: CircularProgressIndicator.adaptive(),
              ),
            ProdsScanningLoaded() =>
              ProdsScanningProdDetailsBody(state.product),
            ProdsScanningError() =>
              const Center(child: Text("Producto no cargado")),
            ProdsScanningScanCancelled() => const Center(
                child: Text("Escaneo cancelado por el usuario"),
              ),
          };
        },
      ),
    );
  }
}
