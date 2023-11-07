import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/providers/auth.dart';
import 'models/product.dart';
import 'screens/auth-screen.dart';
import './screens/edit_product_screen.dart';
import './providers/orders.dart';
import './screens/cart_screen.dart';
import './screens/product_detail_screen.dart';
import './screens/products_overview_screen.dart';
import './providers/products.dart';
import 'providers/cart.dart';
import 'screens/orders_screen.dart';
import 'screens/user_products_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          //If your value doesnt depend on context use this instead of builder/create
          //using normal constructor with create argument is the better approach here
          ChangeNotifierProvider(
            create: (ctx) => Orders(),
          ),
          //doesnt work with the .value() constructor
          ChangeNotifierProvider(
            create: (ctx) => Cart(),
          ),
          ChangeNotifierProvider(
            create: (ctx) => Auth(),
          ),
          ChangeNotifierProxyProvider<Auth, Products>(
            //update: was previously builder:
            update: (ctx, auth, previousProducts) {
              // print(auth.token); //auth token reaches here
              return Products(
                auth.token.toString(),
                previousProducts == null ? [] : previousProducts.items,
              );
            },
            create: (ctx) => Products(
                Provider.of<Auth>(ctx, listen: false).token.toString(), []),
          )
        ],
        child: Consumer<Auth>(
          builder: (ctx, authData, _) => MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Shop demo',
              theme: ThemeData(
                  cardTheme: CardTheme(elevation: 5),
                  // primaryColor: Colors.purple,
                  colorScheme: ColorScheme.fromSwatch(
                    primarySwatch: Colors.blueGrey,
                    accentColor: Colors.deepOrange,
                  )),
              home: authData.isAuth ? ProductsOverviewScreen() : AuthScreen(),
              routes: {
                // ProductsOverviewScreen()
                EditProductScreen.routeName: (ctx) => EditProductScreen(),
                ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
                CartScreen.routeName: (ctx) => CartScreen(),
                OrdersScreen.routeName: (ctx) => OrdersScreen(),
                UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
              }),
        ));
  }
}
