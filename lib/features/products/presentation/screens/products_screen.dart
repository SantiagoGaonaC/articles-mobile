import 'package:articles_flutter/features/products/domain/entities/products.dart';
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
  bool showFavorites = false;
  bool showOnlyFavorites = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      ref.read(productsProvider.notifier).loadNextPage();
    });
  }

  void toggleShowFavorites() {
    setState(() {
      showOnlyFavorites = !showOnlyFavorites;
    });
  }

  void toggleCrossAxisCount() {
    setState(() {
      stateCrossAxis = stateCrossAxis == 1 ? 2 : 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    final productState = ref.watch(productsProvider);
    List<Products> filteredProducts;

    if (showOnlyFavorites) {
      filteredProducts =
          productState.products.where((p) => p.isFavorite).toList();
    } else {
      filteredProducts = productState.products;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: toggleShowFavorites,
                    child: Icon(
                      showOnlyFavorites
                          ? Icons.favorite
                          : Icons.favorite_border_outlined,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: toggleCrossAxisCount,
                    child: const Icon(Icons.swap_horiz_rounded, size: 35),
                  ),
                ],
              )),
          const SizedBox(height: 20),
          Expanded(
            child: MasonryGridView.count(
              crossAxisCount: stateCrossAxis,
              mainAxisSpacing: 20,
              crossAxisSpacing: 20,
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                final product = filteredProducts[index];
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
          child: Image.network(product.imageUrl, fit: BoxFit.contain),
        ),
        const SizedBox(height: 20),
        buildTextDetails(product),
      ];
    }
  }

  Widget buildTextDetails(product) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          product.productName,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
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
            IconButton(
              icon: Icon(
                product.isFavorite
                    ? Icons.favorite
                    : Icons.favorite_border_outlined,
                size: 35,
              ),
              onPressed: () {
                if (product.isFavorite) {
                  print(product.isFavorite);
                  ref.read(productsProvider.notifier).removeFavorite(product);
                } else {
                  ref.read(productsProvider.notifier).addFavorite(product);
                }
              },
            ),
          ],
        ),
      ],
    );
  }
}
