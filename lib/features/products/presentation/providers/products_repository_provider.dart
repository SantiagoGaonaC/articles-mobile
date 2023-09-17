/*
El objetivo del provider es establecer a lo largo de toda la app la instancia de mi product repository implementation
*/

import 'package:articles_flutter/features/auth/presentation/providers/auth_provider.dart';
import 'package:articles_flutter/features/products/domain/repositories/product_repository.dart';
import 'package:articles_flutter/features/products/infrastructure/datasources/product_datasource_impl.dart';
import 'package:articles_flutter/features/products/infrastructure/repositories/product_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final productsRepositoryProvider = Provider<ProductsRepository>((
  ref,
) {
  //el token lo tengo en el otro provider, pero riverpod deja que lo use gracias al (ref)
  final accessToken = ref.watch(authProvider).user?.token ?? '';
  //cualquier cambio que suceda en el auth provider, se va a reflejar en el products repository provider
  final productsRepository =
      ProductsRepositoryImpl(ProductDataSourceImpl(accessToken: accessToken));
  return productsRepository;
});
// Puedo usar lo ofrezca el ProductRepository