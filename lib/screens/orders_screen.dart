import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/app_drawer.dart';
import '../providers/orders.dart' show Orders;
import '../widgets/order_item.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders-screen';

  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ordersData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
          title: Text(
        'Your Orders',
      )),
      drawer: AppDrawer(),
      body: ListView.builder(
        itemBuilder: ((context, index) {
          return OrderItem(ordersData.orders[index]);
        }),
        itemCount: ordersData.orders.length,
      ),
    );
  }
}
