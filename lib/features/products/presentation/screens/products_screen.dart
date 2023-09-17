import 'package:articles_flutter/features/products/presentation/providers/products_provider.dart';
import 'package:articles_flutter/features/shared/widgets/side_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      drawer: SideMenu(scaffoldKey: scaffoldKey),
      appBar: AppBar(
        title: const Text('Products'),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      body: const _ProductsView(),
    );
  }
}

class _ProductsView extends ConsumerStatefulWidget {
  const _ProductsView();

  @override
  _ProductsViewState createState() => _ProductsViewState();
}

class _ProductsViewState extends ConsumerState<_ProductsView> {
  final ScrollController scrollController = ScrollController();
  int stateCrossAxis = 1;
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      ref.read(productsProvider.notifier).loadNextPage();
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
    // TODO: scroll infinito pendiente
  }

  void toggleCrossAxisCount() {
    setState(() {
      stateCrossAxis = stateCrossAxis == 1 ? 2 : 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    final productState = ref.watch(productsProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          // Botón en la parte superior
          ElevatedButton(
            onPressed: toggleCrossAxisCount,
            child: const Text("Cambiar columnas"),
          ),
          // Vista de productos
          Expanded(
            child: MasonryGridView.count(
              physics: const BouncingScrollPhysics(),
              crossAxisCount: stateCrossAxis,
              mainAxisSpacing: 20,
              crossAxisSpacing: 20,
              itemCount: productState.products.length,
              itemBuilder: (context, index) {
                final product = productState.products[index];
                return Center(
                  child: Text(product.productName),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
