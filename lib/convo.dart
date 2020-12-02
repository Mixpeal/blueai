import 'dart:async';
import 'dart:io';

import 'package:BlueAi/preload.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_recognition/speech_recognition.dart';
import 'chat/message_widget.dart';
import 'models/Message.dart';
import 'utils/all_command.dart';
import 'utils/db_helper.dart';
import 'utils/my_functions.dart';

class Convo extends StatefulWidget {
  @override
  _ConvoState createState() => _ConvoState();
}

class _ConvoState extends State<Convo> {
  SpeechRecognition _speechRecognition;
  bool _isAvailable = false;
  bool _isListening = false;
  bool loading = true, error = false, notLoaded = true;
  final List<MessageWidget> _messages = <MessageWidget>[];
  var _controller = ScrollController();

  DBHelper dbHelper;

  String resultText = "";

  void getLocalMessages() async {
    this.setState(() {
      loading = true;
    });
    try {
      List<Message> getchats = await dbHelper.getChatMessages();
      if (getchats != null && getchats.length > 0) {
        fillChats(getchats);
      } else {}

      this.setState(() {
        loading = false;
        error = false;
      });
    } catch (e) {
      this.setState(() {
        loading = false;
        error = true;
      });
      print(e);
    }
  }

  fillChats(List<Message> chats) async {
    if (chats.length > 0) {
      for (var i = 0; i < chats.length; i++) {
        var chat = chats[i];
        MessageWidget addMessage = new MessageWidget(
            msg: chat,
            type: 'pda',
            direction: chat.author == 1 ? "right" : "left",
            actionate: (value) => deleteChat(value));
        var checkElem =
            _messages.where((element) => element.msg.hash == chat.hash);
        if (checkElem.length == 0) {
          setState(() {
            _messages.insert(0, addMessage);
          });
        }
      }
    }
  }

  deleteChat(msg) async {
    try {
      var checkIndex =
          _messages.indexWhere((element) => element.msg.hash == msg.hash);
      setState(() {
        _messages.removeAt(checkIndex);
      });
      await dbHelper.deleteByHash(msg.hash);
    } catch (e) {
      print(e);
    }
  }

  void sendMessage() async {
    var timer = new Timer(const Duration(seconds: 1), () async {
      setState(() => _isListening = false);
      if (resultText.length > 0) {
        String hash = MyFunctions().strRandom(25);
        DateTime today = new DateTime.now();
        String dateSlug =
            "${today.year.toString()}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";
        Message msg = Message(null, hash, resultText, 1, 1, 0, dateSlug);
        await dbHelper.add(msg);
        MessageWidget message = new MessageWidget(
            msg: msg,
            type: 'pda',
            direction: 'right',
            actionate: (value) => deleteChat(value));
        setState(() {
          _messages.insert(0, message);
        });
        createReply();
      }
    });
  }

  createReply() async {
    String hash = MyFunctions().strRandom(25);
    DateTime today = new DateTime.now();
    var reply = await AllCommand().getCommand(resultText);
    String dateSlug =
        "${today.year.toString()}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";
    Message msg = Message(null, hash, reply, 2, 1, 0, dateSlug);
    await dbHelper.add(msg);
    MessageWidget message = new MessageWidget(
        msg: msg,
        type: 'pda',
        direction: 'left',
        actionate: (value) => deleteChat(value));
    setState(() {
      _messages.insert(0, message);
      resultText = "";
    });
  }

  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper();
    var timer = new Timer(const Duration(seconds: 5), () {
      setState(() {
        notLoaded = false;
      });
      this.getLocalMessages();
    });
    checkPermission();
    _speechRecognition = SpeechRecognition();

    _speechRecognition.setAvailabilityHandler(
      (bool result) => setState(() => _isAvailable = result),
    );

    _speechRecognition.setRecognitionStartedHandler(
      () => setState(() => _isListening = true),
    );

    _speechRecognition.setRecognitionResultHandler(
      (String speech) => setState(() => resultText = speech),
    );

    _speechRecognition.setRecognitionCompleteHandler(
      (_) => sendMessage(), 
    );

    _speechRecognition.activate().then(
          (result) => setState(() => _isAvailable = result),
        );
  }

  checkPermission() async {
    if (Platform.isAndroid) {
      var status = await Permission.microphone.status;
      if (!status.isGranted) {
        await Permission.microphone.request();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: speechButton(),
      body: notLoaded
          ? Preload()
          : Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.white,
              child: new Container(
                child: new Column(
                  children: <Widget>[
                    //Chat list
                    _messages != null && _messages.length > 0
                        ? new Flexible(
                            child: new ListView.builder(
                              controller: _controller,
                              padding: new EdgeInsets.all(8.0),
                              reverse: true,
                              itemBuilder: (_, int index) => _messages[index],
                              itemCount: _messages.length,
                            ),
                          )
                        : Flexible(
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 18.0),
                                child: loading
                                    ? CircularProgressIndicator(
                                        strokeWidth: 2,
                                        backgroundColor: Colors.blue,
                                        valueColor:
                                            new AlwaysStoppedAnimation<Color>(
                                                Colors.blue[50]),
                                      )
                                    : error
                                        ? Text("Unable to get conversations")
                                        : Text("You have no conversations yet"),
                              ),
                            ),
                          ),
                  ],
                ),
              )),
    );
  }

  speechButton() => notLoaded
      ? LinearProgressIndicator(
          backgroundColor: Colors.blue,
          minHeight: 1.2,
          valueColor: new AlwaysStoppedAnimation<Color>(Colors.blue[50]),
        )
      : Container(
          height: 100,
          color: Colors.white,
          width: double.infinity,
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              // FloatingActionButton(
              //   child: Icon(Icons.cancel),
              //   mini: true,
              //   backgroundColor: Colors.red,
              //   onPressed: () {
              //     if (_isListening)
              //       _speechRecognition.cancel().then(
              //             (result) => setState(() {
              //               _isListening = result;
              //               resultText = "";
              //             }),
              //           );
              //   },
              // ),
              FloatingActionButton(
                child: Icon(
                  Icons.cancel,
                  size: 40,
                ),
                mini: true,
                backgroundColor: Colors.orange,
                onPressed: () {
                  dbHelper.deleteAll();
                  setState(() {
                    _messages.clear();
                  });
                },
              ),
              _isListening
                  ? Text("Listening...")
                  : FloatingActionButton(
                      child: Icon(Icons.mic),
                      onPressed: () {
                        if (_isAvailable && !_isListening) {
                          print('inside');
                          _speechRecognition
                              .listen(locale: "en_US")
                              .then((result) => print('$result'));
                        } else {
                          _speechRecognition.activate().then(
                                (result) =>
                                    setState(() => _isAvailable = result),
                              );
                          print('outside');
                        }
                      },
                      backgroundColor: Colors.blue,
                    ),
              // FloatingActionButton(
              //   child: Icon(Icons.stop),
              //   mini: true,
              //   backgroundColor: Colors.red,
              //   onPressed: () {
              //     if (_isListening)
              //       _speechRecognition.stop().then(
              //             (result) => setState(() => _isListening = result),
              //           );
              //   },
              // ),
            ],
          ),
        );
}
