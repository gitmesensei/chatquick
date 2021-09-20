import 'package:chatquick/pages/message_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class Contacts extends StatefulWidget {
  @override
  _ContactsState createState() => _ContactsState();
}

class _ContactsState extends State<Contacts> {

  String id;

  void _loadCurrentUser() async {
    User user = FirebaseAuth.instance.currentUser;
    setState(() {
      this.id = user.uid.toString();
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    _loadCurrentUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Users',style: TextStyle(color: Colors.white),),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('Users').where('user_id',isNotEqualTo:id).snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snap) {
            if (!snap.hasData)
              return  Center(
                child: LinearProgressIndicator(),
              );

            return ListView.builder(
                itemCount: snap.data.docs.length,
                scrollDirection: Axis.vertical,
                primary: false,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  DocumentSnapshot user = snap.data.docs[index];
                  String userid = snap.data.docs[index].id;

                  return Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                          border: Border(bottom: BorderSide(color:Colors.white24,width:1))
                      ),
                      child: ListTile(
                        leading: ClipOval(
                          child: user['image']!=null?Image.network(user['image'],fit: BoxFit.cover,):Image.asset('assets/pic1.jpg',fit: BoxFit.cover,),
                        ),
                        title: Text(user['name'].toString().toUpperCase(),style: TextStyle(color: Colors.white),),
                        onTap: (){
                          FirebaseFirestore.instance.collection('Users').doc(id).update({
                            'chats':userid
                          });
                          FirebaseFirestore.instance.collection('Users').doc(userid).update({
                            'chats':id
                          });
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>MessagePage(userid)));

                        },
                      ),
                    ),
                  );
                });
          }),
    );
  }
}
