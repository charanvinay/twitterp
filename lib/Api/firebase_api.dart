import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:twitterp/Models/tweet_model.dart';

class FirebaseApi {
  static Future<String> createTweet(Tweet tweet) async {
    final user = FirebaseAuth.instance.currentUser;
    final docTweet = FirebaseFirestore.instance.collection(user!.uid).doc();

    tweet.id = docTweet.id;
    await docTweet.set(tweet.toJson());

    return docTweet.id;
  }

  static Stream<QuerySnapshot> readTweets() {
    final user = FirebaseAuth.instance.currentUser;
    return FirebaseFirestore.instance
        .collection(user!.uid)
        .orderBy(TweetField.createdTime, descending: true)
        .snapshots();
  }

  static Future updateTweet(Tweet tweet) async {
    final user = FirebaseAuth.instance.currentUser;
    final docTweet =
        FirebaseFirestore.instance.collection(user!.uid).doc(tweet.id);

    await docTweet.update(tweet.toJson());
  }

  static Future deleteTweet(Tweet tweet) async {
    final user = FirebaseAuth.instance.currentUser;
    final docTweet =
        FirebaseFirestore.instance.collection(user!.uid).doc(tweet.id);

    await docTweet.delete();
  }
}
