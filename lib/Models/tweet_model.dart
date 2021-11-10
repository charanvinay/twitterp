import 'package:twitterp/utils.dart';

class TweetField {
  static const createdTime = 'createdTime';
}

class Tweet {
  DateTime createdTime;
  String? id;
  String description;

  Tweet({
    required this.createdTime,
    required this.description,
    this.id,
  });

  static Tweet fromJson(Map<String, dynamic> json) => Tweet(
        createdTime: Utils.toDateTime(json['createdTime']),
        description: json['description'],
        id: json['id'],
      );

  Map<String, dynamic> toJson() => {
        'createdTime': Utils.fromDateTimeToJson(createdTime),
        'description': description,
        'id': id,
      };
}
