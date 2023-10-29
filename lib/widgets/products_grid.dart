import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';
import 'product_item.dart';

class ProductsGrid extends StatelessWidget {
  late final bool showFavorites;

  ProductsGrid(this.showFavorites);

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final products =
        showFavorites ? productsData.favoriteItems : productsData.items;
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 2.5 / 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10),
      //USED .VALUE() METHOD BECAUSE OTHERWISE A PRODUCT IS DISPOSED INSTANTLY
      itemBuilder: ((ctx, index) => ChangeNotifierProvider.value(
            value: products[index],
            child: ProductItem(),
          )),

      // ChangeNotifierProvider(
      //       create: (c) => products[index], // USE THE => OR YOU'LL GET ERRORS??
      //       builder: (context, child) {
      //         //USE BUILDER AND PASS CONTEXT AND CHILD
      //         return ProductItem();
      //       },
      //       // child: ProductItem(), //ERRORS KTEER
      //     )),
      itemCount: products.length,
    );
  }
}
