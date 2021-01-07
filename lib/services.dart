import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:hacker_news/models/news.dart';
import 'package:hacker_news/models/comments.dart';


class Services {
  Future<http.Response> _getNews(int newsId) {
    return http.get("https://hacker-news.firebaseio.com/v0/item/$newsId.json");
  }

  Future<List<http.Response>> getTopStories() async {
    final response = await http.get(
        "https://hacker-news.firebaseio.com/v0/topstories.json?print=pretty");
    if (response.statusCode == 200) {
      Iterable ids = jsonDecode(response.body);
      return Future.wait(ids.take(10).map((id) {
        return _getNews(id);
      }));
    } else {
      throw Exception("Cannot fetch data");
    }
  }
    Future<List<http.Response>> getComments(News news) async {

    return Future.wait(news.commentIds.map((commentId)  { 
        return http.get("https://hacker-news.firebaseio.com/v0/item/${commentId}.json");
    }));

  }

      Future<List<http.Response>> getReplies(Comment comment) async {

    return Future.wait(comment.commentIds.map((commentId)  { 
        return http.get("https://hacker-news.firebaseio.com/v0/item/${commentId}.json");
    }));

  }
}
