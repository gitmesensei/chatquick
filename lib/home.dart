import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatquick/models/size_config.dart';
import 'package:chatquick/onboardingcomp/login.dart';
import 'package:chatquick/pages/all_contacts.dart';
import 'package:chatquick/stories/data.dart';
import 'package:chatquick/stories/stories_main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:chatquick/pages/chat_screen.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          "ChatQuick",
          style: TextStyle(
              color: Colors.white,
              letterSpacing: 2,
              fontWeight: FontWeight.w500),
        ),
        elevation: 0.7,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Contacts()));
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
          ),
          IconButton(
              icon: Icon(Icons.logout),
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => LoginPage()));
              })
        ],
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Material(
              elevation: 10,
              child: Container(
                  margin: EdgeInsets.only(top: 120),
                  height: SizeConfig.blockSizeVertical * 100,
                  child: UserChats()),
            ),
            Container(
              width: double.infinity,
              height: 120,
              decoration: BoxDecoration(color: Colors.black.withOpacity(0.8)),
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  StoryScreen(stories: stories)));
                    },
                    child: Center(
                      child: Container(
                        width: 100,
                        height: 100,
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 35.0,
                              backgroundColor: Colors.grey[300],
                              backgroundImage: CachedNetworkImageProvider(
                                user.profileImageUrl,
                              ),
                            ),
                            const SizedBox(width: 15.0),
                            Expanded(
                              child: Text(
                                user.name,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  StoryScreen(stories: stories)));
                    },
                    child: Center(
                      child: Container(
                        width: 100,
                        height: 100,
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 35.0,
                              backgroundColor: Colors.grey[300],
                              backgroundImage: CachedNetworkImageProvider(
                                user.profileImageUrl,
                              ),
                            ),
                            const SizedBox(width: 15.0),
                            Expanded(
                              child: Text(
                                user.name,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  StoryScreen(stories: stories)));
                    },
                    child: Center(
                      child: Container(
                        width: 100,
                        height: 100,
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 35.0,
                              backgroundColor: Colors.grey[300],
                              backgroundImage: CachedNetworkImageProvider(
                                user.profileImageUrl,
                              ),
                            ),
                            const SizedBox(width: 15.0),
                            Expanded(
                              child: Text(
                                user.name,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  StoryScreen(stories: stories)));
                    },
                    child: Center(
                      child: Container(
                        width: 100,
                        height: 100,
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 35.0,
                              backgroundColor: Colors.grey[300],
                              backgroundImage: CachedNetworkImageProvider(
                                user.profileImageUrl,
                              ),
                            ),
                            const SizedBox(width: 15.0),
                            Expanded(
                              child: Text(
                                user.name,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

