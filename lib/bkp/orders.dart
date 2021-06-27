/*
import 'package:Bit.Me/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../CreateOrderDialog.dart';

class OrdersPage extends StatefulWidget {
  User user;

  OrdersPage(this.user);

  @override
  State<StatefulWidget> createState() {
    return _OrdersPageState();
  }
}

class _OrdersPageState extends State<OrdersPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      //padding: EdgeInsets.all(16),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 0,
          mainAxisSpacing: 0,
          childAspectRatio: 1.0,
        ),
        itemCount: widget.user.userData.orders.length + 1,
        itemBuilder: (context, index) {
          return widget.user.userData.orders.length != index
              ? Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border(
                      right: (index % 2) == 0
                          ? BorderSide(
                              color: Colors.black.withOpacity(0.2), width: 0.5)
                          : BorderSide(width: 0.0, color: Colors.transparent),
                      bottom: BorderSide(
                        color: Colors.black.withOpacity(0.2),
                        width: 0.5,
                      ),
                    ),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${widget.user.userData.orders.values.toList()[index].pair}',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 24),
                        ),
                        Container(
                          height: 4,
                        ),
                        RichText(
                          textAlign: TextAlign.center,
                          softWrap: true,
                          text: TextSpan(
                            text: 'Trading ',
                            style: TextStyle(
                                color: Colors.black.withOpacity(0.4),
                                fontSize: 18),
                            children: <TextSpan>[
                              TextSpan(
                                text:
                                    '${widget.user.userData.orders.values.toList()[index].amount} ${widget.user.userData.orders.values.toList()[index].pair.split("/")[1]}',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                              TextSpan(text: '\n for '),
                              TextSpan(
                                text:
                                    '${widget.user.userData.orders.values.toList()[index].pair.split("/")[0]}',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                              TextSpan(text: '.'),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                )
              : createNewOrder(index);
        },
      ),
    );
  }

  Widget createNewOrder(int index) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return CreateOrderDialog(widget.user);
          },
        );
      },
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border(
            right: (index % 2) == 0
                ? BorderSide(color: Colors.black.withOpacity(0.2), width: 0.5)
                : BorderSide(width: 0.0, color: Colors.transparent),
            bottom: BorderSide(
              color: Colors.black.withOpacity(0.2),
              width: 0.5,
            ),
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.add,
                size: 64,
              ),
              Container(
                height: 4,
              ),
              Text(
                'New Order',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    fontSize: 24),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
*/
