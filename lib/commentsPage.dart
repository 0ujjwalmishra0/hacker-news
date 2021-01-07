import 'package:flutter_svg/flutter_svg.dart';
import 'package:time_formatter/time_formatter.dart';

import './services.dart';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hacker_news/models/news.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:hacker_news/models/comments.dart';

class CommentsPage extends StatefulWidget {
  final List<Comment> comments;
  final News news;

  CommentsPage({this.comments, this.news});

  @override
  _CommentsPageState createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  List<Comment> replies;

  void _showReplies(int index) async {
    final news = this.widget.comments[index];
    final responses = await Services().getReplies(news);
    final comments = responses.map((response) {
      final json = jsonDecode(response.body);
      return Comment.fromJSON(json);
    }).toList();

    setState(() {
      replies = comments;
    });
    print(comments.length);
  }

  buildNewsTitle() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Posted by " +
                                widget.news.author +
                                " \u00b7 " +
                                formatTime(widget.news.time * 1000),
                            style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8),
                          Text(
                            widget.news.title,
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
                                  Text(widget.news.score.toString()),
                                  Text(" "),
                                  Image.asset("images/down-arrow.png",
                                      height: 12, color: Colors.redAccent),
                                ],
                              ),
                              GestureDetector(
                                onTap: () {
                                  // _showCommentsPage(context, ind);
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
                                    widget.news.totalComments == null
                                        ? Text('    ')
                                        : Text(widget.news.totalComments < 10
                                            ? "0" +
                                                widget.news
                                                    .totalComments
                                                    .toString()
                                            : widget.news
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Comments"),
      ),
      backgroundColor: Colors.grey[200],
     body: SingleChildScrollView(
            child: Column(children: [
          buildNewsTitle(),
          
  
        (widget.comments == null || widget.comments.length == 0)
            ? Center(
                child: Text("No comments "),
              )
            : 
               ListView.builder(
                 shrinkWrap: true,
                 physics: NeverScrollableScrollPhysics(),
                itemCount: this.widget.comments.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              this.widget.comments[index].author == null
                                  ? ''
                                  : this.widget.comments[index].author +" \u00b7 " +
                              formatTime(widget.news.time * 1000),
                              style: TextStyle(fontWeight: FontWeight.w500,fontSize: 12),
                            ),
                            Html(
                                data: this.widget.comments[index].text == null
                                    ? ''
                                    : this.widget.comments[index].text),
                            GestureDetector(
                              // key: ,
                              // onTap: () {
                              //   _showReplies(index);
                              //   print(replies.length);
                              // },
                              child: Text(this
                                      .widget
                                      .comments[index]
                                      .commentIds
                                      .length
                                      .toString() +
                                  " replies"),
                            ),

// /*** SECTION: Show Replies section
//  *   Problem faced - Same replies are being show in every comment
//  */
//                           // replies==null || replies.length==0? SizedBox(height: 0,) : SingleChildScrollView(
//                           //                             child: ListView.builder (
//                           //     shrinkWrap: true,
//                           //     scrollDirection: Axis.vertical,
//                           //     itemCount: replies.length,
//                           //     itemBuilder: (BuildContext context, int index) {
//                           //       return Card(
//                           //         color: Colors.blueAccent,
//                           //         child: Padding(
//                           //           padding: const EdgeInsets.all(10.0),
//                           //           child: Container(
//                           //             child: Column(
//                           //               crossAxisAlignment:
//                           //                   CrossAxisAlignment.start,
//                           //               children: [
//                           //                 Text(
//                           //                   this.replies[index].author==null ?'':this.replies[index].author,
//                           //                   style: TextStyle(
//                           //                       fontWeight: FontWeight.bold),
//                           //                 ),
//                           //                 Html(
//                           //                     data:
//                           //                         this.replies[index].text == null
//                           //                             ? ''
//                           //                             : this.replies[index].text),
//                           //               ],
//                           //             ),
//                           //           ),
//                           //         ),
//                           //       );
//                           //     },
//                           //   ),
//                           // ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
        ],),
     ),
    );
  }
}
