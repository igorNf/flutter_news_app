import 'dart:io';
import 'dart:convert';

class NewsService {
  HttpClient client = new HttpClient();
  String URL = "https://newsapi.org/v2/everything";
  String params = "?q=Putin&from=2021-03-10&language=en&pageSize=5&apiKey=a6260451b1ca4dcb811e865f7c4b4e19";

  List<Article> getNews(String query) {

    List<Article> result = [];

    client.getUrl(Uri.parse(URL + "?q=${query}&from=2021-03-10&language=en&pageSize=5&apiKey=a6260451b1ca4dcb811e865f7c4b4e19"))
        .then((HttpClientRequest request) {
          request.headers.set(HttpHeaders.contentTypeHeader, 'application/json; charset=UTF-8');
          return request.close();
        })
        .then((HttpClientResponse response) {
            response.transform(utf8.decoder).transform(json.decoder).listen((Object contents) {

              try {
                var data = contents as Map<String, dynamic>;
                List<dynamic> jsonArticles = data['articles'];

                for (int i = 0; i < jsonArticles.length; i++) {

                  result.add(Article.fromMap(jsonArticles[i]));

                  print(jsonArticles[i]['author']);
                }
              } catch(e) {
                print('Exception has occured $e');
              }
            });
        });

    return result;
  }
}

class Article {
  String author;
  String title;
  String description;
  String url;
  String imageUrl;
  DateTime publishedAt;

  Article(this.author, this.title, this.description, this.url, this.imageUrl, this.publishedAt);
  factory Article.fromMap(Map<String, dynamic> json) {
    return Article(
        json['author'],
        json['title'],
        json['description'],
        json['url'],
        json['urlToImage'],
        DateTime.parse(json['publishedAt'])
    );
  }
}