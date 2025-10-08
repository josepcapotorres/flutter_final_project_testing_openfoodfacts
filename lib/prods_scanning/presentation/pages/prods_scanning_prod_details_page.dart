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

class ProdsScanningProdDetailsPageContent extends StatelessWidget {
  const ProdsScanningProdDetailsPageContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProdsScanningCubit, ProdsScanningState>(
      builder: (context, state) {
        if (state is! ProdsScanningLoaded) {
          return const Scaffold(
            body: Center(child: Text("Producto no cargado")),
          );
        }

        return ProdsScanningProdDetailsBody(state.product);
      },
    );
  }
}
