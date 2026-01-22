import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../Screens/Home/noData_screen.dart';
import 'custom_appbar.dart';
import 'error_utils.dart';

class WebViewPage extends StatefulWidget {
  final String url;
  final String title;
  final bool isBack;

  const WebViewPage(
      {this.url = '', this.isBack = true, Key? key, this.title = ""})
      : super(key: key);

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (Platform.isAndroid) {
        // WebView.platform = SurfaceAndroidWebView();
      }
      // setState(() {});
    });
  }

  WebViewController webViewController = WebViewController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: PopScope(
        canPop: false,
        onPopInvoked: (didPop) async {
          if (await webViewController.canGoBack()) {
            webViewController.goBack();
          } else
            context.pop();
        },
        child: Scaffold(
          appBar: CustomAppbarWidget(
            context: context,
            title: widget.title,
            onPressed: () {
              context.pop();
            },
            isBack: widget.isBack,
          ),
          body: widget.url.isNotEmpty
              ? WebViewWidget(
                  controller: webViewController
                    ..setJavaScriptMode(JavaScriptMode.unrestricted)
                    ..enableZoom(false)
                    ..setBackgroundColor(const Color(0x00000000))
                    ..setNavigationDelegate(
                      NavigationDelegate(
                        onProgress: (int progress) {
                          // Update loading bar.
                          print(progress);
                        },
                        onPageStarted: (String url) async {
                          ErrorUtils.showLoadingDialog(context);
                        },
                        // onUrlChange: (url){
                        //   ErrorUtils.showLoadingDialog(context);
                        //
                        // },
                        onPageFinished: (String url) {
                          print(url);
                          // if(url.contains('.aspx')) {
                          //   ErrorUtils.hideDialog(context);
                          // }
                        },
                        onWebResourceError: (WebResourceError error) {},
                        onNavigationRequest: (NavigationRequest request) {
                          return NavigationDecision.navigate;
                        },
                      ),
                    )
                    ..loadRequest(
                      Uri.parse(widget.url),
                    ))
              : NoDataScreen(
                  title: 'Oops',
                  subtitle:
                      'Something is going on in the Universe...It seems like we’re having some difficulties; please don’t abandon ship, we’re sending for help.',
                  onPressed: () {
                    context.pop();
                  },
                  buttonText: 'Try Again',
                  image: 'assets/wrong.png',
                ),
        ),
      ),
    );
  }
}
