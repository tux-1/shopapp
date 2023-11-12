import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import './screens/splash-body.dart';
import 'generated/l10n.dart';
import '/providers/auth.dart';
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
import './helpers/custom_route.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    return MultiProvider(
        providers: [
          //If your value doesnt depend on context use this instead of builder/create
          //using normal constructor with create argument is the better approach here

          //doesnt work with the .value() constructor
          ChangeNotifierProvider(
            create: (ctx) => Cart(),
          ),
          ChangeNotifierProvider(
            create: (ctx) => Auth(),
          ),
          ChangeNotifierProxyProvider<Auth, Orders>(
            update: (ctx, auth, previousOrders) {
              return Orders(
                auth.token.toString(),
                auth.userId,
                previousOrders == null ? [] : previousOrders.orders,
              );
            },
            create: (ctx) => Orders('', '', []),
          ),
          ChangeNotifierProxyProvider<Auth, Products>(
            //update: was previously builder:
            update: (ctx, auth, previousProducts) {
              // print(auth.token); //auth token reaches here
              return Products(
                auth.token.toString(),
                auth.userId,
                previousProducts == null ? [] : previousProducts.items,
              );
            },
            create: (ctx) => Products('', '', []),
          )
        ],
        child: Consumer<Auth>(
          builder: (ctx, authData, _) => MaterialApp(
              localizationsDelegates: const [
                S.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: S.delegate.supportedLocales,
              // locale: const Locale('ar'), //Change language
              debugShowCheckedModeBanner: false,
              // title: 'Shop demo',
              theme: ThemeData(
                  pageTransitionsTheme: PageTransitionsTheme(builders: {
                    TargetPlatform.android: CustomPageTransitionBuilder(),
                    // TargetPlatform.iOS:,
                  }),
                  listTileTheme: const ListTileThemeData(
                    iconColor: Color(0xffDEA568),
                    // textColor: Colors.white,
                  ),
                  // Define the background color of the app
                  scaffoldBackgroundColor: const Color(0xff1E352F),
                  cardTheme: const CardTheme(elevation: 5),
                  // Define text theme to control the text color
                  textTheme: const TextTheme(
                      bodyMedium: TextStyle(
                    // fontFamily: 'Inter',
                    color: Colors.black,
                  )),
                  // Define the primary color for the app
                  primaryColor: Colors.purple,
                  // Define the accent color used for buttons, icons, etc.
                  colorScheme: ColorScheme.fromSwatch(
                    primarySwatch: Colors.blueGrey,
                    accentColor: const Color(0xffDEA568),
                  ),
                  appBarTheme: const AppBarTheme(
                      iconTheme: IconThemeData(color: Colors.black),
                      titleTextStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 22,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                      ),
                      color: Colors.white,
                      actionsIconTheme: IconThemeData(color: Colors.black))),
              home: authData.isAuth
                  ? ProductsOverviewScreen()
                  : FutureBuilder(
                      future: authData.tryAutoLogin(),
                      builder: (c, authResultSnapshot) =>
                          authResultSnapshot.connectionState ==
                                  ConnectionState.waiting
                              ? const SplashBody()
                              : AuthScreen()),
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
