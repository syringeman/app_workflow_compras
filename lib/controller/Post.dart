class Post {
  final Map<String, dynamic> body;

  Post({this.body});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      body: json['body'],
    );
  }
}