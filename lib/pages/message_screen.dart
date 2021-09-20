import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../fullscreen.dart';

class MessagePage extends StatefulWidget {
  String userId;

  MessagePage(this.userId);

  @override
  _MessagePageState createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  User currentuser;
  bool isMe = false;
  String message;
  File _image = null;
  final picker = ImagePicker();
  String id;
  final messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
  }

  void _loadCurrentUser() async {
    User user = FirebaseAuth.instance.currentUser;
    setState(() {
      this.id = user.uid.toString();
    });
  }

  _load() async {
    await FirebaseFirestore.instance
        .collection("Users")
        .doc(id)
        .update({"chatTime": Timestamp.now()});

    FirebaseFirestore.instance.collection("Users").doc(id).update({
      "chats": FieldValue.arrayUnion([widget.userId])
    });
    FirebaseFirestore.instance
        .collection("Users")
        .doc(widget.userId)
        .update({"chatTime": Timestamp.now()});

    FirebaseFirestore.instance.collection("Users").doc(widget.userId).update({
      "chats": FieldValue.arrayUnion([id])
    });
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      _image = File(pickedFile.path);
    });

    final String randomName = Random().nextInt(10000).toString();

    final Reference storageReference = FirebaseStorage.instance
        .ref()
        .child("post_images")
        .child(randomName + ".jpg");

    final UploadTask uploadTask = storageReference.putFile(_image);

    TaskSnapshot durl = await uploadTask;

    String url = await durl.ref.getDownloadURL();

    storetoDatabase(url);
  }

  void storetoDatabase(url) {
    FirebaseFirestore.instance
        .collection('messages')
        .doc(id)
        .collection(widget.userId)
        .add({
      'message': url,
      "seen": false,
      "type": 1,
      "timestamp": Timestamp.now(),
      "from": id,
    });
    FirebaseFirestore.instance
        .collection('messages')
        .doc(widget.userId)
        .collection(id)
        .add({
      'message': url,
      "seen": false,
      "type": 1,
      "timestamp": Timestamp.now(),
      "from": id,
    });
  }

  @override
  Widget build(BuildContext context) {
    _load();
    return Scaffold(
      backgroundColor: Colors.black,
        body: SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: Colors.pink.shade200,
              boxShadow: [
                BoxShadow(
                  color: Colors.white38,
                  blurRadius: 10,
                ),
              ],
            ),
            child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('Users')
                    .doc(widget.userId)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (!snapshot.hasData) return new Text('Loading....');
                  DocumentSnapshot user = snapshot.data;
                  return Row(
                    children: [
                      IconButton(
                          icon: Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          }),
                      Container(
                        margin: EdgeInsets.all(4),
                        width: 60,
                        height: 60,
                        child: ClipOval(
                          child: user['image'] != null
                              ? Image.network(
                                  user['image'],
                                  fit: BoxFit.cover,
                                )
                              : Image.asset(
                                  'assets/pic1.jpg',
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 5),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(user['name'],
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white)),
                            Text('offline',
                                style: TextStyle(
                                    fontSize: 12, color: Colors.white)),
                          ],
                        ),
                      )
                    ],
                  );
                }),
          ),
          Expanded(
            child: Container(
              child: _messages(widget.userId),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(30.0),
                        border: Border.all(color: Colors.white, width: 2)),
                    child: TextField(
                      maxLines: null,
                      controller: messageController,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white),
                      onChanged: (value) {
                        message = value;
                      },
                      decoration: InputDecoration(
                        hintText: ' type your message here...',
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        suffixIcon: IconButton(
                            icon: Icon(
                              Icons.camera_alt,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              _pickImage(ImageSource.gallery);
                            }),
                      ),
                    ),
                  ),
                ),
                Padding(
                    padding: EdgeInsets.only(left: 4),
                    child: IconButton(
                        icon: Icon(
                          Icons.send,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          if (message.isNotEmpty) {
                            FirebaseFirestore.instance
                                .collection('messages')
                                .doc(id)
                                .collection(widget.userId)
                                .add({
                              'message': message,
                              "seen": false,
                              "type": 0,
                              "timestamp": Timestamp.now(),
                              "from": id,
                            });
                            FirebaseFirestore.instance
                                .collection('messages')
                                .doc(widget.userId)
                                .collection(id)
                                .add({
                              'message': message,
                              "seen": false,
                              "type": 0,
                              "timestamp": Timestamp.now(),
                              "from": id,
                            });

                            messageController.clear();
                          } else {
                            return Text('enter some text');
                          }
                          return Text('enter text');
                        })),
              ],
            ),
          )
        ],
      ),
    ));
  }

  Widget _messages(userId) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('messages')
            .doc(id)
            .collection(userId)
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snap) {
          if (!snap.hasData) return new Text('....');
          if (snap.hasError)
            return Center(
              child: CircularProgressIndicator(),
            );
          return new ListView.builder(
              itemCount: snap.data.docs.length,
              primary: true,
              reverse: true,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                DocumentSnapshot ds = snap.data.docs[index];
                Timestamp timestamp = ds['timestamp'];

                if (ds['from'].toString() == id) {
                  isMe = true;
                } else {
                  isMe = false;
                }
                return Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: isMe
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: _date(timestamp.millisecondsSinceEpoch),
                        ),
                        Material(
                          borderRadius: isMe
                              ? BorderRadius.only(
                                  topLeft: Radius.circular(30.0),
                                  bottomLeft: Radius.circular(30.0),
                                  bottomRight: Radius.circular(30.0),
                                )
                              : BorderRadius.only(
                                  topRight: Radius.circular(30.0),
                                  bottomLeft: Radius.circular(30.0),
                                  bottomRight: Radius.circular(30.0)),
                          elevation: 5.0,
                          color: isMe ? Colors.white : Colors.pink.shade200,
                          child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 20.0),
                              child: ds['type'] == 0
                                  ? Text(
                                      ds['message'],
                                      style: TextStyle(
                                          color: isMe
                                              ? Colors.black54
                                              : Colors.white,
                                          fontSize: 15.0),
                                    )
                                  : InkWell(
                                      child: Image.network(
                                        ds['message'],
                                        width: 250.0,
                                        fit: BoxFit.fill,
                                      ),
                                      onTap: () {
                                        if (ds['type'] == 1) {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      FullScreen(
                                                          ds['message'])));
                                        }
                                      },
                                    )),
                        ),
                      ],
                    ));
              });
        });
  }

  Widget _date(timestamp) {
    var now = new DateTime.now();
    var date = new DateTime.fromMillisecondsSinceEpoch(timestamp);
    var format = new DateFormat('HH:mm a');
    var diff = now.difference(date);
    var time = '';

    if (diff.inSeconds <= 0 ||
        diff.inSeconds > 0 && diff.inMinutes == 0 ||
        diff.inMinutes > 0 && diff.inHours == 0 ||
        diff.inHours > 0 && diff.inDays == 0) {
      time = format.format(date);
    } else if (diff.inDays > 0 && diff.inDays < 7) {
      if (diff.inDays == 1) {
        time = diff.inDays.toString() + ' DAY AGO';
      } else {
        time = diff.inDays.toString() + ' DAYS AGO';
      }
    } else {
      if (diff.inDays == 7) {
        time = (diff.inDays / 7).floor().toString() + ' WEEK AGO';
      } else {
        time = (diff.inDays / 7).floor().toString() + ' WEEKS AGO';
      }
    }

    return Text(
      time.toLowerCase(),
      style: TextStyle(fontSize: 12, color: Colors.grey),
    );
  }
}
