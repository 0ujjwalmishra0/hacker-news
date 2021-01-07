import 'package:flutter/material.dart';
import 'package:hacker_news/widgets/myListView.dart';
import 'package:hacker_news/models/news.dart';


class VisitedPage extends StatelessWidget {
 final List<News> _visitedNews;
  VisitedPage(this._visitedNews);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Visted News"),
      ),
      body: MyListView(news: _visitedNews,needProvider: false,),
    );
  }
}
