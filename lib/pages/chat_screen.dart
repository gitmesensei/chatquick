import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

import 'message_screen.dart';

class UserChats extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<UserChats> with TickerProviderStateMixin {
  User currentuser;
  AnimationController animationController;
  DocumentSnapshot doc;
  int docum;
  Timestamp timestamp;
  bool seen;
  var type;
  String id;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    _loadCurrentUser();
  }

  bool isSwitched = true;

  void _loadCurrentUser() async {
    User user = FirebaseAuth.instance.currentUser;
    setState(() {
      this.id = user.uid.toString();
    });
  }
  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
        body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('Users')
                .where('chats', arrayContains: id)
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError)
                return Center(
                  child: CircularProgressIndicator(),
                );
              if (!snapshot.hasData)
                return Center(child: CircularProgressIndicator());
              if (snapshot.data.docs.isEmpty)
                return Center(
                  child: Container(
                    width: 300,
                    height: 100,
                    child: Center(
                      child: Text(' you do not have any conversation',
                          style: TextStyle(color: Colors.black)),
                    ),
                  ),
                );

              return ListView.builder(
                    itemCount: snapshot.data.docs.length,
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                  padding: EdgeInsets.only(top: 5),
                    itemBuilder: (context, index) {
                      String userId = snapshot.data.docs[index].id;
                      DocumentSnapshot user = snapshot.data.docs[index];
                      Timestamp timestamp = user['chatTime'];
                      final int count = snapshot.data.docs.length > 10 ? 10 :
                      snapshot.data.docs.length;
                      final Animation<double> animation =
                      Tween<double>(begin: 0.0, end: 1.0).animate(
                          CurvedAnimation(
                              parent: animationController,
                              curve: Interval(
                                  (1 / count) * index, 1.0,
                                  curve: Curves.fastOutSlowIn)));
                      animationController.forward();
                      return AnimatedBuilder(
                          animation: animationController,
                          builder: (BuildContext context, Widget child) {
                          return FadeTransition(
                            opacity: animation,
                            child: Transform(
                              transform: Matrix4.translationValues(
                                  0.0, 50 * (1.0 - animation.value), 0.0),
                              child: Container(
                                padding: const EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  border: Border(bottom: BorderSide(color:Colors.white24,width:1))
                                ),
                                child: ListTile(
                                  leading: ClipOval(
                                      child: user['image'] == null
                                          ? Image.asset(
                                        'assets/pic1.jpg',
                                        fit: BoxFit.cover,
                                      ) :Image.network(
                                        user['image'],
                                        fit: BoxFit.cover,
                                      ) ),
                                  title: Text(
                                    user['name'],
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  subtitle: Row(
                                    children: <Widget>[
                                      StreamBuilder(
                                          stream: FirebaseFirestore.instance
                                              .collection('messages')
                                              .doc(id)
                                              .collection(userId)
                                              .orderBy('timestamp')
                                              .snapshots(),
                                          builder: (BuildContext context,
                                              AsyncSnapshot<QuerySnapshot> snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting)
                                              return Text('.....');
                                            if (!snapshot.hasData)
                                              return new Text('Loading....');
                                            if(snapshot.data == null)
                                              return new Text('Loading....');
                                            doc = snapshot.data.docs.last;
                                            seen = doc['seen'];
                                            type = doc['type'];
                                            return Text(doc['message'],
                                                style: TextStyle(color: Colors.grey));
                                          }),
                                    ],
                                  ),
                                  trailing:  _date(timestamp != null
                                      ? timestamp.millisecondsSinceEpoch
                                      : ''),
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => MessagePage(userId)));
                                  },
                                  onLongPress: () {
                                    //chat delete here with dialog
                                  },
                                ),
                              ),
                            ),
                          );
                        }
                      );
                    });
            }));
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
