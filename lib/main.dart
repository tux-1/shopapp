import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
        //using normal constructor with create argument is the better approach here
        ChangeNotifierProvider(
          create: (ctx) => Orders(),
        ),
        ChangeNotifierProvider(
          // value: Products(),
          //If your value doesnt depend on context use this instead of builder/create
          create: (ctx) => Products(),
        ),
        //doesnt work with the .value() constructor
        ChangeNotifierProvider(
          create: (ctx) => Cart(),
        ),
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Shop demo',
          theme: ThemeData(
              cardTheme: CardTheme(elevation: 5),
              // primaryColor: Colors.purple,
              colorScheme: ColorScheme.fromSwatch(
                primarySwatch: Colors.blueGrey,
                accentColor: Colors.deepOrange,
              )),
          home: AuthScreen(),
          routes: {
            // ProductsOverviewScreen()
            EditProductScreen.routeName: (ctx) => EditProductScreen(),
            ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
            CartScreen.routeName: (ctx) => CartScreen(),
            OrdersScreen.routeName: (ctx) => OrdersScreen(),
            UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
          }),
    );
  }
}
