import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../injection_container.dart';
import '../../../prods_scanning/presentation/blocs/prods_scanning_cubit.dart';
import '../../../prods_scanning/presentation/blocs/prods_scanning_state.dart';
import '../../../prods_scanning/presentation/pages/prods_scanning_prod_details_page.dart';
import '../blocs/scanned_prods_cubit.dart';
import '../blocs/scanned_prods_state.dart';
import '../widgets/scanned_prods_grid.dart';

class ScannedProdsPage extends StatelessWidget {
  const ScannedProdsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ProdsScanningCubit>(
          create: (_) => sl<ProdsScanningCubit>(),
        ),
        BlocProvider<ScannedProdsCubit>(create: (_) => sl<ScannedProdsCubit>()),
      ],
      child: const ScannedProdsContent(),
    );
  }
}

class ScannedProdsContent extends StatefulWidget {
  const ScannedProdsContent({super.key});

  @override
  State<ScannedProdsContent> createState() => _ScannedProdsContentState();
}

class _ScannedProdsContentState extends State<ScannedProdsContent> {
  @override
  void initState() {
    super.initState();

    context.read<ScannedProdsCubit>().getPreviousScannedProds();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Productos escaneados"),
        actions: [
          IconButton(
            onPressed: () async {
              context.read<ProdsScanningCubit>().scanAndGetProductDetails();
            },
            icon: Icon(Icons.barcode_reader),
          ),
        ],
      ),
      body: BlocConsumer<ProdsScanningCubit, ProdsScanningState>(
        listenWhen: (oldState, newState) => oldState != newState,
        listener: (context, state) {
          if (state is ProdsScanningLoaded) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              context.read<ScannedProdsCubit>().getPreviousScannedProds();

              Navigator.pushNamed(
                context,
                ProdsScanningProdDetailsPage.route,
              );
            });
          } else if (state is ProdsScanningScanCancelled) {
            _showSnackBar("Escaneo cancelado por el usuario");
          } else if (state is ProdsScanningError) {
            _showSnackBar("Error al obtener los datos del producto");
          }
        },
        builder: (context, state) {
          return BlocBuilder<ScannedProdsCubit, ScannedProdsState>(
            builder: (_, state) {
              return switch (state) {
                ScannedProdsInitial() => const SizedBox.shrink(),
                ScannedProdsLoading() => const Center(
                    child: CircularProgressIndicator.adaptive(),
                  ),
                ScannedProdsEmpty() => const Center(
                    child: Text("No hay elementos escaneados aún"),
                  ),
                ScannedProdsLoaded(:final products) =>
                  ScannedProdsGrid(products),
              };
            },
          );
        },
      ),
    );
  }

  void _showSnackBar(String message) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
        ),
      );
    });
  }
}
