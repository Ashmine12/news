import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewScreen extends StatefulWidget {
  const WebViewScreen({super.key, required this.newsUrl});
  final String newsUrl;

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  WebViewController? webViewController;
  var loadingPercentage = 0;
  Uri? url;
  String errorMessage = '';
  @override
  void initState() {
    super.initState();
    url = Uri.parse(widget.newsUrl);
    webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(
        onPageStarted: (url) {
          setState(() {
            loadingPercentage = 0;
          });
        },
        onProgress: (progress) {
          setState(() {
            loadingPercentage = progress;
          });
        },
        onPageFinished: (url) {
          setState(() {
            loadingPercentage = 100;
          });
        },
        onWebResourceError: (error) {
          setState(() {
            debugPrint(error.description);
            errorMessage =
            'No Data Found Please Try again later.';
            loadingPercentage = 0;
          });
        },
      ))
      ..loadRequest(url!);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'News App',
          ),
        ),
        body: Center(
          child: errorMessage.isNotEmpty
              ? Text(
            errorMessage,
            style: TextStyle(color: Colors.red),
          )
              : Stack(
            children: [
              WebViewWidget(
                controller: webViewController!,
              ),
              if (loadingPercentage < 100)
                LinearProgressIndicator(
                  value: loadingPercentage / 100.0,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
