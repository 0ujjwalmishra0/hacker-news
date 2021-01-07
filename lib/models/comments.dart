class Comment {
  String text;
  int commentId;
  String author;
  int time;
  int totalReplies;
  List<int> commentIds = List<int>();
  Comment({
    this.text,
    this.commentId,
    this.author,
    this.time,
    this.commentIds,
    this.totalReplies,
  });

/** Deserializing Json data */

  factory Comment.fromJSON(Map<String, dynamic> json) {
    return Comment(
      commentId: json["id"],
      author: json["by"],
      time: json["time"],
      text: json["text"],
      commentIds: json["kids"] == null ? List<int>() : json["kids"].cast<int>(),
      totalReplies: json["descendants"],
    );
  }
}
