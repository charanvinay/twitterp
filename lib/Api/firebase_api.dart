import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:twitterp/Models/tweet_model.dart';

class FirebaseApi {
  static Future<String> createTweet(Tweet tweet) async {
    final docTweet = FirebaseFirestore.instance.collection('tweet').doc();

    tweet.id = docTweet.id;
    await docTweet.set(tweet.toJson());

    return docTweet.id;
  }

  static Stream<QuerySnapshot> readTweets() {
    return FirebaseFirestore.instance
        .collection('tweet')
        .orderBy(TweetField.createdTime, descending: true)
        .snapshots();
  }

  static Future updateTweet(Tweet tweet) async {
    final docTweet =
        FirebaseFirestore.instance.collection('tweet').doc(tweet.id);

    await docTweet.update(tweet.toJson());
  }

  static Future deleteTweet(Tweet tweet) async {
    final docTweet =
        FirebaseFirestore.instance.collection('tweet').doc(tweet.id);

    await docTweet.delete();
  }
}
