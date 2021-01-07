
class News {
  String title;
  String url;
  int score;
  String author;
  int time;
  int totalComments;
  List<int> commentIds = List<int>();
  News(
      {this.score,
      this.totalComments,
      this.author,
      this.time,
      this.title,
      this.url,
      this.commentIds});

/** Deserializing Json data */

  factory News.fromJSON(Map<String, dynamic> json) {
    return News(
      title: json["title"],
      url: json["url"],
      score: json["score"],
      author: json["by"],
      time: json["time"],
      totalComments: json["descendants"],
      commentIds: json["kids"] == null ? List<int>() : json["kids"].cast<int>(),
    );
  }

}
