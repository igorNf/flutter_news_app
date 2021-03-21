import 'package:flutter/material.dart';

import 'package:collection/collection.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:transparent_image/transparent_image.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:news_app/dto/article.dart';


TextEditingController controller = new TextEditingController();

Future<List<Article>> fetchNews(String query) async {
  print("QUERY ======  ${query}");

  final response = await http.get(Uri.parse("https://newsapi.org/v2/everything" + "?q=${query}&from=2021-03-10&language=en&pageSize=100&apiKey=a6260451b1ca4dcb811e865f7c4b4e19"));
  if (response.statusCode == 200) {

    List<Article> result = [];
    List<dynamic> jsonArticles = jsonDecode(response.body)['articles'];
    for (int i = 0; i < jsonArticles.length; i++) {
      result.add(Article.fromMap(jsonArticles[i]));
    }
    return result;
  } else {
    throw Exception('Failed to load news');
  }
}

Future<List<Article>> articles;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Поиск новостей',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Найди новость'),
          backgroundColor: Color(0xffed9e37)
        ),
        body: Center(
            child: SearchForm()
        )
      )
    );
  }
}

class SearchForm extends StatefulWidget {
  @override
  SearchFormState createState() {
    return SearchFormState();
  }
}

class SearchFormState extends State<SearchForm> {

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    return Form(
        key: _formKey,
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Container(
                width: 320,
                child: TextFormField(validator: (value) {
                  if(value.isEmpty) {
                    return "Введите строку для поиска";
                  }
                  return null;
                }, controller: controller,),
              ),
              OutlinedButton(
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Processing Data: ${controller.text}')));
                      Navigator.push(context, MaterialPageRoute<void>(builder: (BuildContext context) {
                        return Scaffold(
                          appBar: AppBar(title: Text('Новости')),
                          body: Container(
                            color: Colors.white,
                            child: News(),
                            width: 380,
                            height: 650,
                          ),
                        );
                      }));
                    }
                  },
                  child: Icon(Icons.search)
              )
            ]
        )
    );
  }
}


class News extends StatefulWidget {

  @override
  _NewsState createState() => _NewsState();
}

class _NewsState extends State<News> {

  List<Widget> list = [];

  @override
  void initState() {
    super.initState();
    articles = fetchNews(controller.text);
  }

  @override
  Widget build(BuildContext context) {

    return FutureBuilder<List<Article>>(future: articles,
    builder: (context, snapshot) {
      if (snapshot.hasError) {
        print("Есть ошибки:  ${snapshot.error}");
      }
      return snapshot.hasData ? _buildNews(snapshot.data) : Center(child: CircularProgressIndicator());
    });
  }

  Widget _buildNews(articles) {
    return ListView(
        padding: EdgeInsets.all(16.0),
        children: _buildItems(articles)
        );
  }

  List<Widget> _buildItems(List<Article> articles) {
    articles.sort((a, b) => -1 * a.fullDate.compareTo(b.fullDate));
    var newMap = groupBy(articles, (obj) => obj.date);

    for (MapEntry<dynamic, List<Article>> entry in newMap.entries) {
      list.add(Center(child: Text(entry.key, style: Theme.of(context).textTheme.headline5),));
      for (Article article in entry.value) {
        list.add(ArticleCard(article: article));
      }
      list.add(Divider());
    }

    return list;
  }
}

class ArticleCard extends StatelessWidget {

  final Article article;
  ArticleCard({Key key, this.article}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          FadeInImage.memoryNetwork(
            placeholder: kTransparentImage,
            image: article.imageUrl ?? 'https://via.placeholder.com/150',
          ),
          ListTile(
            title: Text(article.title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => ArticleDetails(article: article,)));
            },
          )

        ],),
    );
  }
}

class ArticleDetails extends StatelessWidget {
  final Article article;
  ArticleDetails({Key key, this.article}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(article.author),),
      body: Column(
        children: [
          Image.network(article.imageUrl ?? 'https://via.placeholder.com/150'),
          Text(article.description ?? ''),
          InkWell(
            child: Text('Открыть в браузере'),
            onTap: () => launch(article.url),
          )
        ],
      ),
    );
  }
}
