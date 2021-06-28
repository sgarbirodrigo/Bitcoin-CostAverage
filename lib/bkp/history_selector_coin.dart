import 'package:Bit.Me/bkp/history_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../main_pages/dashboard.dart';
import '../main_pages/settings.dart';
import '../models/settings_model.dart';
import '../models/user_model.dart';
import '../main_pages/orders_Page.dart';

class HistorySelPage extends StatefulWidget {
  Settings settings;
  User user;

  HistorySelPage(
    this.user,
    this.settings,
  );

  @override
  State<StatefulWidget> createState() {
    return _HistorySelPageState();
  }
}

class _HistorySelPageState extends State<HistorySelPage> {
  int position = 0;
  PageController _myPage;

  @override
  void initState() {
    _myPage = PageController(
      initialPage: position,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(top: 16, bottom: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                    onPressed: () {
                      if (position > 0)
                        position++;
                      else
                        position = widget.user.pairDataItems.length - 1;
                      widget.settings.updateBasePair(widget
                          .user.pairDataItems.values
                          .toList()[position]
                          .pair);
                      _myPage.jumpToPage(position);
                    },
                    icon: Icon(Icons.chevron_left)),
                Text(
                  "${widget.settings.base_pair}",
                  style: TextStyle(
                      fontSize: 24,
                      color: Colors.deepPurple,
                      fontFamily: 'Arial Rounded MT Bold'),
                ),
                IconButton(
                  onPressed: () {
                    if (position == widget.user.pairDataItems.length - 1)
                      position = 0;
                    else
                      position++;
                    widget.settings.updateBasePair(widget
                        .user.pairDataItems.values
                        .toList()[position]
                        .pair);
                    _myPage.jumpToPage(position);
                  },
                  icon: Icon(Icons.chevron_right),
                )
              ],
            ),
          ),
          Expanded(
              child: PageView.builder(
            allowImplicitScrolling: false,
            physics: NeverScrollableScrollPhysics(),
            controller: _myPage,
            itemCount: widget.user.pairDataItems.values.toList().length,
            itemBuilder: (context, index) {
              return HistoryPage(widget.user, widget.settings,
                  widget.user.pairDataItems.values.toList()[index]);
            },
          )),
        ],
      ),
    );
  }
}
