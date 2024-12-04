import 'package:get/get.dart';
import 'package:news_app/models/article_model.dart';
import 'package:news_app/repository/api_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert'; // For JSON serialization

class NewsController extends GetxController {
  final NewsService _newsService = NewsService();

  RxList<NewsArticle> newsList = <NewsArticle>[].obs;
  RxList<NewsArticle> bookmarkedArticles =
      <NewsArticle>[].obs;
  RxBool isLoading = false.obs;
  RxBool hasError = false.obs;
  RxString selectedCategory = 'general'.obs;
  RxString searchKeyword = ''.obs;

  // List of categories
  List<String> categories = [
    'general',
    'business',
    'entertainment',
    'health',
    'science',
    'sports',
    'technology'
  ];

  Future<void> fetchNews(
      {String category = 'general', int page = 1, String keyword = ''}) async {
    try {
      isLoading.value = true;
      hasError.value = false;

      // Fetch the news articles from the service
      final List<NewsArticle> articles = await _newsService.fetchTopHeadlines(
        category: category,
        page: page,
        keyword: keyword,
      );


      newsList.value = articles;
    } catch (e) {
      print('Error fetching news: $e');
      hasError.value = true;
    } finally {
      isLoading.value = false;
    }
  }

  // Add article to bookmarks
  void addToBookmarks(NewsArticle article) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> bookmarks = prefs.getStringList('bookmarks') ?? [];

    if (!bookmarks.contains(article.url)) {
      bookmarks.add(jsonEncode(article.toJson()));
      await prefs.setStringList('bookmarks', bookmarks);
      _loadBookmarks();
    }
  }

  // Load bookmarked articles from local storage
  void _loadBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> bookmarks = prefs.getStringList('bookmarks') ?? [];
    bookmarkedArticles.value =
        bookmarks.map((e) => NewsArticle.fromJson(jsonDecode(e))).toList();
  }

  // Remove article from bookmarks
  void removeFromBookmarks(NewsArticle article) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> bookmarks = prefs.getStringList('bookmarks') ?? [];
    bookmarks.removeWhere((item) => item.contains(article.url));
    await prefs.setStringList('bookmarks', bookmarks);
    _loadBookmarks();
  }

  @override
  void onInit() {
    super.onInit();
    fetchNews(category: 'general', page: 1); // Initial fetch
    _loadBookmarks();
  }
}
