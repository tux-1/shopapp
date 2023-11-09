import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';
import '../screens/orders_screen.dart';
import '../screens/user_products_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(children: [
        AppBar(
          title: Text('Hello "User"!'),
          automaticallyImplyLeading: false,
        ),
        const Divider(),
        ListTile(
            leading: Icon(Icons.shop),
            title: Text('Shop'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            }),
        const Divider(),
        ListTile(
            leading: const Icon(Icons.payment),
            title: const Text('Orders'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(OrdersScreen.routeName);
            }),
        const Divider(),
        ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Your Products'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(UserProductsScreen.routeName);
            }),
        const Divider(),
        Spacer(),
        ListTile(
            leading: const Icon(
              Icons.logout,
            ),
            title: const Text('Log out',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                )),
            onTap: () {
              Navigator.of(context).pop(); //to close the drawer
              Provider.of<Auth>(context, listen: false).logOut();
            }),
      ]),
    );
  }
}
