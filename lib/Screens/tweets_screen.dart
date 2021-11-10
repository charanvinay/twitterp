import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:twitterp/Api/firebase_api.dart';
import 'package:twitterp/Models/tweet_model.dart';
import 'package:twitterp/Provider/google_sign_in.dart';
import 'package:twitterp/Provider/tweets_provider.dart';

class TweetsScreen extends StatefulWidget {
  const TweetsScreen({Key? key}) : super(key: key);

  @override
  _TweetsScreenState createState() => _TweetsScreenState();
}

class _TweetsScreenState extends State<TweetsScreen> {
  final _formKey = GlobalKey<FormState>();
  late String description;

  late TweetsProvider tweetsProvider;

  @override
  void initState() {
    tweetsProvider = Provider.of<TweetsProvider>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: () {
              Provider.of<GoogleSignInProvider>(context, listen: false)
                  .logout();
            },
            child: Text(
              "Logout",
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Consumer<TweetsProvider>(
                          builder: (context, tweetProvider, _) {
                            return Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(5),
                                    ),
                                    border: Border.all(width: 1),
                                  ),
                                  child: TextFormField(
                                    controller: tweetProvider.descController,
                                    keyboardType: TextInputType.multiline,
                                    minLines: 2,
                                    maxLines: null,
                                    onChanged: (value) {
                                      tweetProvider.tweetTextLength(value);
                                    },
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(280),
                                    ],
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      isDense: true,
                                      hintText: "Enter a tweet",
                                      contentPadding: EdgeInsets.all(10),
                                      hintStyle: TextStyle(fontSize: 13),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: Text(
                                    "${tweetProvider.tweetLength} characters left",
                                    style: TextStyle(fontSize: 11),
                                  ),
                                ),
                                SizedBox(height: 10),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.blue,
                                    onPrimary: Colors.white,
                                    minimumSize: Size(double.infinity, 50),
                                  ),
                                  onPressed: addTweet,
                                  child: Text("Add tweet"),
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseApi.readTweets(),
                  builder: (context, snapshot) {
                    final tweetsList = snapshot.data;
                    // final tweetsList = tweetsProvider.tweetsList;
                    if (snapshot.hasError) {
                      return Text('Something went wrong');
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    return tweetsList!.docs.isEmpty
                        ? Center(
                            child: Text(
                              'No tweets.',
                              style: TextStyle(fontSize: 20),
                            ),
                          )
                        : ListView.builder(
                            physics: BouncingScrollPhysics(),
                            padding: EdgeInsets.all(16),
                            shrinkWrap: true,
                            itemCount: tweetsList.docs.length,
                            itemBuilder: (context, index) {
                              Tweet selectedTweet = Tweet.fromJson(
                                  tweetsList.docs[index].data()
                                      as Map<String, dynamic>);
                              return GestureDetector(
                                onTap: () {
                                  // tweetsProvider.removeTweet(data);
                                  tweetsProvider.setDesc(
                                      selectedTweet.description,
                                      selectedTweet.id!);
                                  tweetsProvider.tweetTextLength(
                                      selectedTweet.description);
                                  tweetsProvider.setEdit();
                                  print(
                                      "text : ${tweetsProvider.descController.text} ${tweetsProvider.isEdit}");
                                },
                                child: Dismissible(
                                  key: UniqueKey(),
                                  direction: DismissDirection.endToStart,
                                  onDismissed: (direction) {
                                    tweetsProvider.removeTweet(selectedTweet);
                                  },
                                  background: Align(
                                    alignment: Alignment.centerRight,
                                    child: Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                  ),
                                  child: Card(
                                    elevation: 1,
                                    child: ListTile(
                                      title: Text(selectedTweet.description),
                                      subtitle: Text(user!.displayName!),
                                      trailing: Text(DateFormat.Hm()
                                          .format(selectedTweet.createdTime)),
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void addTweet() {
    final isempty = tweetsProvider.descController.text.isNotEmpty;
    if (!isempty) {
      return;
    } else {
      if (tweetsProvider.isEdit) {
        final tweet = Tweet(
          id: tweetsProvider.id,
          description: tweetsProvider.descController.text,
          createdTime: DateTime.now(),
        );
        tweetsProvider.updateTweet(tweet, tweetsProvider.descController.text);
        print("desc : ${tweet.description}");
        print("desc : ${tweet.id}");
      } else {
        final tweet = Tweet(
          id: DateTime.now().toString(),
          description: tweetsProvider.descController.text,
          createdTime: DateTime.now(),
        );
        tweetsProvider.addTweet(tweet);
      }
      tweetsProvider.setDesc("", DateTime.now().toString());
      tweetsProvider.resetLength();
    }
  }
}
