
class NewsArticle {
   String title;
   String description;
   String urlToImage;
   String url;
   String publishedAt;
   String content;

  NewsArticle({
    required this.title,
    required this.description,
    required this.urlToImage,
    required this.url,
    required this.publishedAt,
    required this.content,
  });


  factory NewsArticle.fromJson(Map<String, dynamic> json) {
    return NewsArticle(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      urlToImage: json['urlToImage'] ?? '',
      url: json['url'] ?? '',
      publishedAt: json['publishedAt'] ?? '',
      content: json['content']??"No data"
    );
  }
   Map<String, dynamic> toJson() {
     return {
       'title': title,
       'description': description,
       'content': content,
       'urlToImage': urlToImage,
       'url': url,
     };
   }

}
