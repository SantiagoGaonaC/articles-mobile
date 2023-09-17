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
          Align(
            alignment: Alignment.bottomRight,
            child: ElevatedButton(
              onPressed: toggleCrossAxisCount,
              child: const Icon(Icons.swap_horiz_rounded, size: 35),
            ),
          ),
          const SizedBox(height: 20),
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
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: stateCrossAxis == 1
                          ? Row(
                              children: buildCardDetails(product),
                            )
                          : Column(
                              children: buildCardDetails(product),
                            ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> buildCardDetails(product) {
    if (stateCrossAxis == 1) {
      return [
        Image.network(product.imageUrl, width: 50, height: 50),
        const SizedBox(width: 20),
        Expanded(child: buildTextDetails(product)),
      ];
    } else {
      return [
        SizedBox(
          height: 200,
          width: double.infinity,
          child: Image.network(product.imageUrl, fit: BoxFit.cover),
        ),
        const SizedBox(height: 20),
        buildTextDetails(product),
      ];
    }
  }

  Widget buildTextDetails(product) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          product.productName,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(
          product.vendor,
          style: const TextStyle(fontSize: 16),
        ),
        Row(
          children: [
            Text(
              product.rating.toString(),
              style: const TextStyle(fontSize: 16),
            ),
            const Spacer(),
            const Icon(
              Icons.star,
              color: Colors.yellow,
              shadows: [
                Shadow(
                  color: Colors.black,
                  blurRadius: 2,
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
