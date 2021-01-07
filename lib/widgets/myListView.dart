import 'package:flutter/material.dart';
import 'package:hacker_news/models/VisitedNewsModel.dart';
import 'package:hacker_news/commentsPage.dart';
import 'package:hacker_news/models/news.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';
import '../services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:time_formatter/time_formatter.dart';

import 'package:hacker_news/models/comments.dart';

class MyListView extends StatelessWidget {
  MyListView({
    Key key,
    @required List<News> news,
    this.visitedNews,
    this.needProvider,
  })  : _news = news,
        super(key: key);

  final List<News> _news;
  final List<News> visitedNews;
  final bool needProvider;
  final currentTime = new DateTime.now().microsecondsSinceEpoch;
  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _showCommentsPage(BuildContext context, int index) async {
    final news = this._news[index];
    final responses = await Services().getComments(news);
    final comments = responses.map((response) {
      final json = jsonDecode(response.body);
      return Comment.fromJSON(json);
    }).toList();

    // print("$comments");

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CommentsPage(news: news, comments: comments),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print("myListView.dart is built");
    return ListView.builder(
        itemCount: _news.length,
        shrinkWrap: true,
        itemBuilder: (ctx, ind) {
          return SingleChildScrollView(
            child: Card(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15),
                child: GestureDetector(
                  onTap: () {
                    print(_news[ind].url);
                    if (needProvider) {
                      Provider.of<VisitedNewsModel>(context, listen: false)
                          .add(_news[ind]);
                    }
                    _launchURL(_news[ind].url);
                  },
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Posted by " +
                              _news[ind].author +
                              " \u00b7 " +
                              formatTime(_news[ind].time * 1000),
                          style: TextStyle(fontSize: 12,fontWeight: FontWeight.w500),
                        ),
                        SizedBox(height: 8),
                        Text(
                          _news[ind].title,
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Image.asset(
                                  "images/up-arrow.png",
                                  height: 12,
                                  color: Colors.redAccent,
                                ),
                                Text(" "),
                                Text(_news[ind].score.toString()),
                                Text(" "),
                                Image.asset("images/down-arrow.png",
                                    height: 12, color: Colors.redAccent),
                              ],
                            ),
                            GestureDetector(
                              onTap: () {
                                _showCommentsPage(context, ind);
                              },
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                    "images/chat.svg",
                                    height: 14,
                                    color: Colors.redAccent,
                                  ),
                                  Text("  "),
                                  // This api has some missing comments, to handle those display blank Text()
                                  _news[ind].totalComments == null
                                      ? Text('    ')
                                      : Text(_news[ind].totalComments < 10
                                          ? "0" +
                                              _news[ind]
                                                  .totalComments
                                                  .toString()
                                          : _news[ind]
                                              .totalComments
                                              .toString()),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }
}
