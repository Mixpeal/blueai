import 'package:BlueAi/models/Message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:linkable/linkable.dart';

class MessageWidget extends StatefulWidget {
  MessageWidget({this.msg, this.direction, this.actionate, this.type});

  final Message msg;
  final String direction, type;
  final Function actionate;

  @override
  _MessageWidgetState createState() => _MessageWidgetState();
}

class _MessageWidgetState extends State<MessageWidget> {
  bool opened = false, leftSelected = false, rightSelected = false;

  @override
  Widget build(BuildContext context) {
    bool isMe = widget.direction == 'left' ? false : true;
    return Container(
      margin: EdgeInsets.only(
          right: widget.direction == 'left' ? 30.0 : 0.0,
          left: widget.direction == 'left' ? 6.0 : 30.0),
      child: new Container(
        margin: const EdgeInsets.symmetric(vertical: 4.0),
        child: new Column(
          crossAxisAlignment: widget.direction == 'left'
              ? CrossAxisAlignment.start
              : CrossAxisAlignment.end,
          children: <Widget>[
            Stack(
              children: [
                //for right corner
                Align(
                  alignment: widget.direction == 'left'
                      ? Alignment.bottomLeft
                      : Alignment.bottomRight,
                  child: Slidable(
                    actionPane: SlidableDrawerActionPane(),
                    actionExtentRatio: 0.25,
                    actions: !isMe
                        ? [
                            Container(
                              decoration: new BoxDecoration(
                                color: Colors.red,
                                border: new Border.all(
                                    color: widget.direction == 'left'
                                        ? Colors.blue[50]
                                        : Colors.blue[100],
                                    width: .25,
                                    style: BorderStyle.solid),
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(5.0),
                                  topLeft: Radius.circular(5.0),
                                  bottomRight: Radius.circular(5.0),
                                  bottomLeft: Radius.circular(5.0),
                                ),
                              ),
                              child: IconSlideAction(
                                color: Colors.transparent,
                                icon: Icons.delete,
                                onTap: () => widget.actionate(widget.msg),
                              ),
                            ),
                          ]
                        : null,
                    secondaryActions: isMe
                        ? [
                            Container(
                              decoration: new BoxDecoration(
                                color: Colors.red,
                                border: new Border.all(
                                    color: widget.direction == 'left'
                                        ? Colors.blue[50]
                                        : Colors.blue[100],
                                    width: .25,
                                    style: BorderStyle.solid),
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(5.0),
                                  topLeft: Radius.circular(5.0),
                                  bottomRight: Radius.circular(5.0),
                                  bottomLeft: Radius.circular(5.0),
                                ),
                              ),
                              child: IconSlideAction(
                                color: Colors.transparent,
                                icon: Icons.delete,
                                onTap: () => widget.actionate(widget.msg),
                              ),
                            ),
                          ]
                        : null,
                    child: new Container(
                      margin: EdgeInsets.only(
                          right: 6.0,
                          left: widget.direction == 'left' ? 0.0 : 6.0),
                      decoration: new BoxDecoration(
                        color: widget.direction == 'left'
                            ? Colors.blue[50]
                            : Colors.blue[100],
                        border: new Border.all(
                            color: widget.direction == 'left'
                                ? Colors.blue[50]
                                : Colors.blue[100],
                            width: .25,
                            style: BorderStyle.solid),
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(25.0),
                          topLeft: Radius.circular(25.0),
                          bottomRight: Radius.circular(25.0),
                          bottomLeft: Radius.circular(25.0),
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 15),
                      child: Column(
                        crossAxisAlignment: widget.direction == 'left'
                            ? CrossAxisAlignment.start
                            : CrossAxisAlignment.end,
                        children: [
                          Linkable(
                            style: new TextStyle(
                              fontSize: 17.0,
                              color: Colors.black,
                            ),
                            text: widget.msg.body != null ? widget.msg.body: '',
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
