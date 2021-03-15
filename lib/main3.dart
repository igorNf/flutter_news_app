import 'package:flutter/material.dart';
import 'package:news_app/services/news_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


TextEditingController controller = new TextEditingController();

Future<List<Article>> fetchNews(String query) async {
  print("QUERY ======  ${query}");

  // final response = new NewsService().getNews(query);

  final response = await http.get(Uri.parse("https://newsapi.org/v2/everything" + "?q=${query}&from=2021-03-10&language=en&pageSize=5&apiKey=a6260451b1ca4dcb811e865f7c4b4e19"));
  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    List<Article> result = [];
    List<dynamic> jsonArticles = jsonDecode(response.body)['articles'];
    for (int i = 0; i < jsonArticles.length; i++) {

      result.add(Article.fromMap(jsonArticles[i]));

      print(jsonArticles[i]['author']);
    }
    return result;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }

  // var resp = [
  //   new Article("Igor", "Путин украл хлеб в магазине", "Это произошло накануне вечером", "https://google.com", "https://static.reuters.com/resources/r/?m=02&d=20210310&t=2&i=1554399916&r=LYNXMPEH290ZN&w=800", DateTime.parse("2021-03-10T13:01:31Z")),
  //   new Article("Igor", "Илон Маск запустил ракету", "Это произошло накануне вечером", "https://google.com", "https://techcrunch.com/wp-content/uploads/2019/04/twitter-app-icon-ios.jpg?w=711", DateTime.parse("2021-03-10T13:01:31Z")),
  //   new Article("Igor", "Соседи жалуются на сильный шум", "Это произошло накануне вечером", "https://google.com", "https://ichef.bbci.co.uk/news/1024/branded_news/429A/production/_112705071_hi061775136.jpg", DateTime.parse("2021-03-10T13:01:31Z"))
  // ];
  //
  //
  // var future = Future.delayed(Duration(seconds: 3), () => resp);
  // return future;
}

Future<List<Article>> articles;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Поиск новостей',
      home: Scaffold(
        appBar: AppBar(title: Text('Последние новости')),
        body: Column(
          children: [
            MyCustomForm(),
          ],
        )
      )
    );
  }
}


class MyCustomForm extends StatefulWidget {
  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

class MyCustomFormState extends State<MyCustomForm> {

  final _formKey = GlobalKey<FormState>();

  String content = "";

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
                          appBar: AppBar(title: Text('Новости'),),
                          body: Container(
                            color: Colors.white,
                            child: News(),
                            width: 380,
                            height: 600,
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

    print("controller   ${controller.text}");

    for (int i = 0; i < articles.length; i++) {
      list.add(Text(articles[i].publishedAt.toIso8601String(), style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)));
      list.add(Text(articles[i].title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)));
      list.add(Image.network(articles[i].imageUrl));
      list.add(Divider());
    }
    return list;
  }
}
