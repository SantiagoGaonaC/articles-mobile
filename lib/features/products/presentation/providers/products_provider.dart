/*
El state es como quiero que se vea la info del stado del provider products
STATE - NOTIFIER - PROVIDER
Provider va a consumir el (Repositorio -> DataSource -> Backend)
DataSource tiene las conexiones e implementaciones necesarias
El provider Tiene la implementación del repositorio, el cual se conecta al dataSource
Nos permite a nosotros llegar a nuestro backend directamente
*/
import 'package:articles_flutter/features/products/domain/entities/products.dart';
import 'package:articles_flutter/features/products/domain/repositories/product_repository.dart';
import 'package:articles_flutter/features/products/presentation/providers/products_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final productsProvider =
    StateNotifierProvider<ProductsNotifier, ProductsState>((ref) {
  final productsRepository = ref.watch(productsRepositoryProvider);
  return ProductsNotifier(productsRepository: productsRepository);
});

class ProductsNotifier extends StateNotifier<ProductsState> {
  final ProductsRepository productsRepository;

  ProductsNotifier({required this.productsRepository})
      : super(
            ProductsState()); //tan pronto el ProductsNotifier se instancie, va a tener un estado inicial

  /*
  Necesito hacer el repositorio para poder hacer la petición (que cumpla la condición y que esté instanciado) 
  */
  Future loadNextPage({bool loadFavorites = false}) async {
    final products = loadFavorites
        ? await productsRepository.getFavorites()
        : await productsRepository.getProducts();

    final updatedProducts = products.map((p) {
      final isFavorite = state.products.any((existingProduct) =>
          existingProduct.id == p.id && existingProduct.isFavorite);
      return p.copyWith(isFavorite: isFavorite);
    }).toList();

    state = state.copyWith(
      products: updatedProducts.isEmpty ? state.products : updatedProducts,
    );
  }

  Future addFavorite(Products product) async {
    try {
      await productsRepository.addFavorite(product);
      final updatedProducts = state.products.map((p) {
        if (p.id == product.id) {
          return p.copyWith(isFavorite: true);
        }
        return p;
      }).toList();
      state = state.copyWith(products: updatedProducts);
    } catch (e) {
      print(e);
    }
  }

  Future removeFavorite(Products product) async {
    try {
      await productsRepository.removeFavorite(product);
      final updatedProducts = state.products.map((p) {
        if (p.id == product.id) {
          return p.copyWith(isFavorite: false);
        }
        return p;
      }).toList();
      state = state.copyWith(
        products: updatedProducts,
      );
    } catch (e) {
      print(e);
    }
  }
}

class ProductsState {
  final List<Products> products; // lista de productos

  ProductsState({
    this.products = const [],
  });

  ProductsState copyWith({
    List<Products>? products,
  }) {
    return ProductsState(
      products: products ?? this.products,
    );
  }
}
