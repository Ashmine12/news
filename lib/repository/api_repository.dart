import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:news_app/models/article_model.dart';
class NewsService {
  final String apiUrl = "https://newsapi.org/v2/top-headlines";

  Future<List<NewsArticle>> fetchTopHeadlines({
    String category = 'general',
    int page = 1,
    String keyword = '',
  }) async {
    final queryParameters = {
      'category': category,
      'page': page.toString(),
      //we need to change apikey after 100 api request
      'apiKey': '32eb19e35dcf43568c3938307e992067',
      'q': keyword,
    };

    final uri = Uri.parse(apiUrl).replace(queryParameters: queryParameters);
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);

      // Filter out articles with '[Removed]' in the title
      List<dynamic> filteredArticles = data['articles'].where((article) {
        return article['title'] != null && !article['title'].contains('[Removed]');
      }).toList();

      return filteredArticles.map((article) => NewsArticle.fromJson(article)).toList();
    } else {
      throw Exception('Failed to load news');
    }
  }
}


