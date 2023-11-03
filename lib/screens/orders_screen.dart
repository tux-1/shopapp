import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/app_drawer.dart';
import '../providers/orders.dart' show Orders;
import '../widgets/order_item.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = '/orders-screen';

  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  // var _isLoading = false;

  @override
  void initState() {
    //use this wrap if you want to set listen: true
    // Future.delayed(Duration.zero).then((_) async {

    //    there's an alternative being introduced instead of initState()
    //    instead of using a statefulWidget
    // _isLoading = true;
    // Provider.of<Orders>(context, listen: false).fetchAndSetOrders().then((_) {
    //   setState(() {
    //     _isLoading = false;
    //   });
    // });
    // });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final ordersData = Provider.of<Orders>(context);
    // Commented out because it would make an infinite loop as it's a listener
    // and FutureBuilder below notifies listeners which will make this rebuild
    // the widget which will start up the FutureBuilder again etc..
    return Scaffold(
        appBar: AppBar(
            title: const Text(
          'Your Orders',
        )),
        drawer: const AppDrawer(),
        body: FutureBuilder(
          //This is the alternative to using StatefulWidget here
          future:
              Provider.of<Orders>(context, listen: false).fetchAndSetOrders(),
          //this future can be stored outside to avoid rebuilding
          //but we dont have any rebuild logic here so i'll leave future here
          builder: (ctx, dataSnapshot) {
            if (dataSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else {
              if (dataSnapshot.connectionState == ConnectionState.done) {
                return Consumer<Orders>(builder: (ctx, ordersData, child) {
                  return ListView.builder(
                    itemBuilder: ((context, index) {
                      return OrderItem(ordersData.orders[index]);
                    }),
                    itemCount: ordersData.orders.length,
                  );
                });
              } else {
                return const Center(
                  child: Text('An error occured'),
                );
              }
            }
          },
        ));
  }
}
