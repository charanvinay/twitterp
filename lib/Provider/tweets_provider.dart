import 'package:flutter/cupertino.dart';
import 'package:twitterp/Api/firebase_api.dart';
import 'package:twitterp/Models/tweet_model.dart';

class TweetsProvider extends ChangeNotifier {
  int tweetLength = 280;
  bool isEdit = false;
  String id = DateTime.now().toString();
  TextEditingController descController = TextEditingController();

  List<Tweet> tweetsList = [];

  tweetTextLength(String value) {
    tweetLength = 280 - value.length;
    notifyListeners();
  }

  resetLength() {
    tweetLength = 280;
    notifyListeners();
  }

  setDesc(String text, String selectedid) {
    descController.text = text;
    id = selectedid;
    notifyListeners();
  }

  setEdit() {
    isEdit = true;
    notifyListeners();
  }

  resetEdit() {
    isEdit = false;
    notifyListeners();
  }

  void setTweets(List<Tweet> tweets) {
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      tweetsList = tweets;
      notifyListeners();
    });
  }

  void addTweet(Tweet tweet) => FirebaseApi.createTweet(tweet);

  void removeTweet(Tweet tweet) => FirebaseApi.deleteTweet(tweet);

  void updateTweet(Tweet tweet, String desc) {
    tweet.description = desc;
    print("desc : ${tweet.description}");
    print("desc : ${tweet.id}");

    FirebaseApi.updateTweet(tweet);
  }
}
