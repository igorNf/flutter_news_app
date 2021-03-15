import 'dart:convert';
import 'dart:io';

import 'package:news_app/services/news_service.dart';


void main() {
 NewsService newsService = new NewsService();
 var news = newsService.getNews("Putin");

 for(int i = 0; i <news.length; i++)
    print(news[i].description);
    print("======================");
}


Future getMessage() {
  // для эмуляции длительной операции делаем задержку в 3 секунды
  return Future.delayed(Duration(seconds: 3), () => print("Пришло новое сообщение от Тома"));
}

