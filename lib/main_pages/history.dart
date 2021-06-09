import 'package:bitbybit/models/user_model.dart';
import 'package:bitbybit/order_list_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class HistoryPage extends StatefulWidget {
  HistoryPage(this.user);

  User user;

  @override
  State<StatefulWidget> createState() {
    return _HistoryPageState();
  }
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      //height: MediaQuery.of(context).size.height*0.7,
      child: Column(
        //mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            //height: 130,
            child: FutureBuilder<QuerySnapshot>(
              future: Firestore.instance
                  .collection("users")
                  .document(widget.user.firebasUser.uid)
                  .collection("history")
                  .getDocuments(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: snapshot.data.documents.length,
                      itemBuilder: (context, index) {
                        return OrderListItem(
                          querySnapshotData: snapshot.data.documents[index],
                          userUid: widget.user.firebasUser.uid,
                        );
                      });
                } else {
                  return Center(child: CircularProgressIndicator(),);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
