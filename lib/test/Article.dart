class Article {
  String author;
  String title;
  String description;
  String url;
  String imageUrl;

  Article(this.author, this.title, this.description, this.url, this.imageUrl);
  factory Article.fromMap(Map<String, dynamic> json) {
    return Article(
        json['author'],
        json['title'],
        json['description'],
        json['url'],
        json['urlToImage']
    );
  }
}