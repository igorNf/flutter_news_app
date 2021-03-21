import 'package:intl/intl.dart';

class Article {
  String author;
  String title;
  String description;
  String url;
  String imageUrl;
  DateTime fullDate;
  String date;
  String time;

  Article(this.author, this.title, this.description, this.url, this.imageUrl, this.fullDate, this.date, this.time);
  factory Article.fromMap(Map<String, dynamic> json) {
    final DateFormat dateFormat = DateFormat('dd-MM-yyyy');
    final DateFormat timeFormat = DateFormat('HH:mm');
    DateTime fullDate = DateTime.parse(json['publishedAt']);
    return Article(
      json['author'],
      json['title'],
      json['description'],
      json['url'],
      json['urlToImage'],
      fullDate,
      dateFormat.format(fullDate),
      timeFormat.format(fullDate),
    );
  }
}