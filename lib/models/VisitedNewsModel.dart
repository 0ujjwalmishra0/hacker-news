import 'package:flutter/cupertino.dart';
import 'package:hacker_news/models/news.dart';

class VisitedNewsModel extends ChangeNotifier {
  final List<News> _visitedNews = [];

  List<News> get visitedNews =>  _visitedNews;

  void add(News news) {
    if(!_visitedNews.contains(news)){
      _visitedNews.add(news);
    }
    notifyListeners();
  }
}
