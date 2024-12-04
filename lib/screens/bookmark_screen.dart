
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:news_app/controllers/controller.dart';
import 'package:news_app/screens/new_detail_screen.dart';
import 'package:news_app/widgets/common_background.dart';

class BookmarkScreen extends StatelessWidget {
  const BookmarkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final newsController = Get.find<NewsController>();

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text('Bookmarks')),
        body: Obx(() {
          if (newsController.bookmarkedArticles.isEmpty) {
            return CommonBackground(
              child: const Center(
                child: Text(
                  'No bookmarks yet.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                  ),
                ),
              ),
            );
          }

          return CommonBackground(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Number of columns
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.75,
                ),
                itemCount: newsController.bookmarkedArticles.length,
                itemBuilder: (context, index) {
                  final article = newsController.bookmarkedArticles[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              NewsDetailScreen(article: article),
                        ),
                      );
                    },
                    child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CachedNetworkImage(
                              imageUrl: article.urlToImage.isNotEmpty
                                  ? article.urlToImage
                                  : 'https://imgs.search.brave.com/LmWIxob5IpfFcour2pZggvcL_qsbWmERiweIuoZgo8o/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly93d3cu/aW1hZ2V0b3RleHQu/aW5mby93ZWJfYXNz/ZXRzL2Zyb250ZW5k/L2ltZy9pY29ucy90/b29sLWJveC1pbWFn/ZS5zdmc',
                              fit: BoxFit.cover,
                              height: 120,
                              width: double.infinity,
                              placeholder: (context, url) => const Center(
                                  child: CircularProgressIndicator()),
                              errorWidget: (context, url, error) => const Center(
                                child: Icon(
                                  Icons.image_not_supported,
                                  color: Colors.grey,
                                  size: 40,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                article.title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                article.description,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        }),
      ),
    );
  }
}
