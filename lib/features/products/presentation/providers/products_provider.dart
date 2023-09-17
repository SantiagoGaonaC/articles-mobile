//El state es como quiero que se vea la info del stado del provider products
// STATE - NOTIFIER - PROVIDER
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
  Future loadNextPage() async {
    if (state.isLoading || state.isLastPage) {
      return; //si esta cargando o es la ultima pagina no hago nada
    }

    state = state.copyWith(isLoading: true); //cambio el estado a isLoading true

    final products =
        await productsRepository.getProducts(); //TODO: limit y offset

    if (products.isEmpty) {
      state = state.copyWith(isLoading: false, isLastPage: true);
      return;
    }

    state = state.copyWith(
      isLastPage: false,
      isLoading: false,
      offset: state.offset + 10,
      products: [...state.products, ...products],
    );
  }
}

class ProductsState {
  final bool isLastPage; //si es la ultima pagina
  final int limit; // cuantos productos quiero que se muestren 10 en 10 20 en 20
  final int offset; // desde donde quiero que empiece a mostrar
  final bool isLoading; // si esta cargando
  final List<Products> products; // lista de productos

  ProductsState({
    this.isLastPage = false,
    this.limit = 10,
    this.offset = 0,
    this.isLoading = false,
    this.products = const [],
  });

  ProductsState copyWith({
    bool? isLastPage,
    int? limit,
    int? offset,
    bool? isLoading,
    List<Products>? products,
  }) {
    return ProductsState(
      isLastPage: isLastPage ?? this.isLastPage,
      limit: limit ?? this.limit,
      offset: offset ?? this.offset,
      isLoading: isLoading ?? this.isLoading,
      products: products ?? this.products,
    );
  }
}
