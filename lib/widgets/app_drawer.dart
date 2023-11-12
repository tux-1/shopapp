import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';
import '../screens/orders_screen.dart';
import '../screens/user_products_screen.dart';
import '../helpers/custom_route.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xff1E352F),
      child: Column(children: [
        AppBar(
          title: const Text('Hello "User"!'),
          automaticallyImplyLeading: false,
        ),
        const Divider(),
        ListTile(
            leading: const Icon(Icons.shop),
            title: const Text(
              'Shop',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            }),
        const Divider(),
        ListTile(
            leading: const Icon(Icons.payment),
            title: const Text(
              'Orders',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(OrdersScreen.routeName
                  // CustomRoute(
                  //   builder: (ctx) => const OrdersScreen(),
                  // ),
                  );
            }),
        const Divider(),
        ListTile(
            leading: const Icon(Icons.edit),
            title: const Text(
              'Your Products',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(UserProductsScreen.routeName);
            }),
        const Divider(),
        const Spacer(),
        ListTile(
            leading: const Icon(
              Icons.logout,
            ),
            title: const Text('Log out',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                )),
            onTap: () {
              Navigator.of(context).pop(); //to close the drawer
              Navigator.of(context).pushReplacementNamed('/');
              //to prevent any unexpected behavior
              Provider.of<Auth>(context, listen: false).logOut();
            }),
      ]),
    );
  }
}
