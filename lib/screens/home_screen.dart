import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:news_app/controllers/controller.dart';
import 'package:news_app/models/article_model.dart';
import 'package:news_app/screens/bookmark_screen.dart';
import 'package:news_app/screens/new_detail_screen.dart';
import 'dart:ui';

import 'package:news_app/widgets/common_background.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final NewsController newsController = Get.put(NewsController());
  final ScrollController scrollController = ScrollController();
  final TextEditingController searchController = TextEditingController();
  bool isSearching = false;

  @override
  void initState() {
    super.initState();

    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        newsController.fetchNews(
            category: newsController.selectedCategory.value,
            page: 2,
            keyword: newsController.searchKeyword.value);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: isSearching
              ? SizedBox(
            height: 45,
                child: TextField(
                    controller: searchController,
                    decoration: const InputDecoration(
                      hintText: 'Search news...',
                      hintStyle: TextStyle(color: Colors.black),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(20),
                        ),
                      ),
                    ),
                    style: const TextStyle(color: Colors.black),
                    onSubmitted: (value) {
                      newsController.searchKeyword.value = value;
                      newsController.fetchNews(
                          category: newsController.selectedCategory.value,
                          page: 1,
                          keyword: value);
                      setState(() {
                        isSearching = false;
                      });
                    },
                  ),
              )
              : const Text('News'),
          actions: [
            IconButton(
              icon: Icon(isSearching ? Icons.clear : Icons.search),
              onPressed: () {
                setState(() {
                  if (isSearching) {
                    isSearching = false;
                    searchController.clear();
                    newsController.searchKeyword.value = '';
                    newsController.fetchNews(
                        category: newsController.selectedCategory.value, page: 1);
                  } else {
                    isSearching = true;
                  }
                });
              },
            ),
            IconButton(
              icon: const Icon(Icons.bookmark),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const BookmarkScreen(),
                  ),
                );
              },
            )
          ],
        ),
        body: Obx(() {
          if (newsController.isLoading.value && newsController.newsList.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          return CommonBackground(
            child: Column(
              children: [
                SizedBox(
                  height: 50,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: newsController.categories.length,
                      itemBuilder: (context, index) {
                        final category = newsController.categories[index];
                        return Padding(
                          padding: const EdgeInsets.only(right: 10.0),
                          child: GestureDetector(
                            onTap: () {
                              newsController.selectedCategory.value = category;
                              newsController.fetchNews(
                                  category: category,
                                  page: 1,
                                  keyword: newsController.searchKeyword.value);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15.0, vertical: 10.0),
                              decoration: BoxDecoration(
                                color: newsController.selectedCategory.value ==
                                        category
                                    ? Colors.white
                                    : Colors.blueAccent.withOpacity(0.7),
                                borderRadius: BorderRadius.circular(30.0),
                                border: Border.all(color: Colors.white),
                              ),
                              child: Center(
                                child: Text(
                                  category.capitalizeFirst!,
                                  style: TextStyle(
                                    color:
                                        newsController.selectedCategory.value ==
                                                category
                                            ? Colors.black
                                            : Colors.white70,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GridView.builder(
                      controller: scrollController,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, // Number of columns
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 0.75,
                      ),
                      itemCount: newsController.newsList.length,
                      itemBuilder: (context, index) {
                        NewsArticle article = newsController.newsList[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  NewsDetailScreen(article: article),
                            ));
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
                                    errorWidget: (context, url, error) =>
                                        const Center(
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
                                      article.title, // Use the model's field
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: Text(
                                      article
                                          .description, // Use the model's field
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
                ),
                if (newsController.isLoading.value &&
                    newsController.newsList.isNotEmpty)
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Center(child: CircularProgressIndicator()),
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
