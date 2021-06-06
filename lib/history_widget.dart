import 'package:bitbybit/order_list_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class HistoryWidget extends StatefulWidget {
  QuerySnapshot querySnapshotData;
  String documentId;

  HistoryWidget(this.querySnapshotData, this.userUid);

  String userUid;

  @override
  State<StatefulWidget> createState() {
    return _HistoryWidgetState();
  }
}

class _HistoryWidgetState extends State<HistoryWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height*0.7,
      child: Column(
        //mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding:
                    EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 16),
                child: Text(
                  "Trade\'s History",
                  style: TextStyle(
                    fontFamily: 'Arial Rounded MT Bold',
                    fontSize: 24,
                    shadows: <Shadow>[
                      Shadow(
                        offset: Offset(1.0, 1.0),
                        blurRadius: 10,
                        color: Color.fromARGB(10, 0, 0, 0),
                      )
                    ],
                  ),
                ),
              ),
              Expanded(child: Container()),
            ],
          ),
          Expanded(
            //height: 130,
            child: FutureBuilder<QuerySnapshot>(
              future: Firestore.instance
                  .collection("users")
                  .document(widget.userUid)
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
                          userUid: widget.userUid,
                        );
                      });
                } else {
                  return CircularProgressIndicator();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
