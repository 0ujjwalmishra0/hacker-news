import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:hacker_news/models/VisitedNewsModel.dart';
import 'package:hacker_news/models/news.dart';
import 'package:hacker_news/services.dart';
import 'package:provider/provider.dart';

import './visitedPage.dart';
import './widgets/myListView.dart';


/// This is the first page of the app


class FirstPage extends StatefulWidget {
  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  List listResponse;
  List<News> _news = List<News>();

  String title;
  String url;

/** Fetch top stories from Hacker News api */ 

  void _topStories() async {
    final responses = await Services().getTopStories();
    final news = responses.map((response) {
      final json = jsonDecode(response.body);
      return News.fromJSON(json);
    }).toList();

    setState(() {
      _news = news;
    });
  }

  @override
  void initState() {
    super.initState();
    _topStories();
  }

  @override
  Widget build(BuildContext context) {
    List<News> visitedNewsprovider =
        Provider.of<VisitedNewsModel>(context, listen: false).visitedNews;
    print("news length is");
    print(_news.length);
    return Scaffold(
      appBar: AppBar(
        title: Text("Hacker News"),
        actions: [
          Container(
            width: 35,
            /** This button displays the no. of visited news 
             *  Also on clicking, it directs to visited news page
            */
            child: FloatingActionButton(
              backgroundColor: Colors.white,
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => VisitedPage(visitedNewsprovider)));
              },
              /** Using Consumer widget of Provider package
               *  It rebuilds only this Text() widget when a news url is opened
               */
              child: Consumer<VisitedNewsModel>(
                builder: (context, cart, child) {
                  return Text(
                    visitedNewsprovider.length.toString(),
                    style: TextStyle(color: Colors.red, fontSize: 16),
                  );
                },
              ),
              tooltip: 'Visited News',
            ),
          ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
      backgroundColor: Colors.grey[200],
      body: 
      /** if _news list is empty display a progerss indicator
       * Otherwise show news using custom ListView widget(inside widget folder)
       */
      (_news.isEmpty || _news == null)
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(12.0),
              child: MyListView(
                news: _news,
                visitedNews: visitedNewsprovider,
                needProvider: true,
              ),
            ),
    );
  }
}
