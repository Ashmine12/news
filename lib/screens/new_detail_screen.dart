import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import 'package:news_app/controllers/controller.dart';
import 'package:news_app/models/article_model.dart';
import 'package:news_app/screens/webview_screen.dart';


class NewsDetailScreen extends StatelessWidget {
  final NewsArticle article;

  const NewsDetailScreen({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    final newsController = Get.find<NewsController>();

    return Scaffold(
      appBar: AppBar(
        title: Text(article.title),
        actions: [
          Obx(() {
            final isBookmarked = newsController.bookmarkedArticles
                .any((item) => item.url == article.url);

            return IconButton(
              icon: Icon(
                isBookmarked ? Icons.bookmark : Icons.bookmark_add_outlined,
                color: isBookmarked ? Colors.black : Colors.black,
              ),
              onPressed: () {
                if (isBookmarked) {
                  newsController.removeFromBookmarks(article);
                } else {
                  newsController.addToBookmarks(article);
                }
              },
            );
          }),
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: CachedNetworkImage(
              imageUrl: article.urlToImage,
              placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) => const Center(
                child: Icon(
                  Icons.image_not_supported,
                  color: Colors.grey,
                  size: 50,
                ),
              ),
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              child: Container(
                color: Colors.black.withOpacity(0.5),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: CachedNetworkImage(
                    imageUrl: article.urlToImage,
                    placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) => const Center(
                      child: Icon(
                        Icons.image_not_supported,
                        color: Colors.grey,
                        size: 50,
                      ),
                    ),
                    fit: BoxFit.cover,
                    height: 250,
                    width: double.infinity,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  article.title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  article.description,
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                  textAlign: TextAlign.justify,
                ),
                const SizedBox(height: 20),
                Text(
                  article.content,
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                  textAlign: TextAlign.justify,
                ),
                const SizedBox(height: 60),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => WebViewScreen(newsUrl: article.url),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 30.0),
                    textStyle: const TextStyle(fontSize: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text('Read Full Article'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
