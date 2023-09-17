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

  @override
  Widget build(BuildContext context) {
    final productState = ref.watch(productsProvider);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: MasonryGridView.count(
        physics: const BouncingScrollPhysics(),
        crossAxisCount: 2,
        mainAxisSpacing: 20,
        crossAxisSpacing: 20,
        itemCount: productState.products.length,
        itemBuilder: (context, index) {
          final product = productState.products[index];
          return Text(product.productName);
        },
      ),
    );
  }
}
