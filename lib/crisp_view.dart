import 'package:crisp_sdk/common/crisp_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:url_launcher/url_launcher.dart';

import 'controller/crisp_controller.dart';

/// The main widget to provide the view of the chat
class CrispView extends StatefulWidget {
  /// The controller to manage the chat
  final CrispController crispController;

  /// Set to true to have all the browser's cache cleared before the new WebView is opened. The default value is false.
  final bool clearCache;

  /// A callback that is invoked when a link is pressed.
  final void Function(String url)? onLinkPressed;

  ///Set to true to make the background of the WebView transparent.
  ///If your app has a dark theme,
  ///this can prevent a white flash on initialization. The default value is false.
  final bool transparentBackground;

  /// A callback that is invoked when the session id is received.
  /// This is useful to track the user's session.
  /// The session id is a unique identifier for the user's session.
  final void Function(String sessionId)? onSessionIdReceived;

  @override
  _CrispViewState createState() => _CrispViewState();

  const CrispView({
    super.key,
    required this.crispController,
    this.clearCache = false,
    this.onLinkPressed,
    this.transparentBackground = false,
    this.onSessionIdReceived,
  });
}

class _CrispViewState extends State<CrispView> {
  String? _javascriptString;

  late InAppWebViewSettings _options;

  @override
  void initState() {
    super.initState();
    _options = InAppWebViewSettings(
      transparentBackground: widget.transparentBackground,
      clearCache: widget.clearCache,
      useShouldOverrideUrlLoading: true,
      mediaPlaybackRequiresUserGesture: false,
      cacheMode: CacheMode.LOAD_CACHE_ELSE_NETWORK,
      allowsInlineMediaPlayback: true,
    );

    _javascriptString = """
      var a = setInterval(function(){
        if (typeof \$crisp !== 'undefined'){
          ${widget.crispController.commands.join(';\n')}
          clearInterval(a);
        }
      },500)
      """;
    widget.crispController.onSessionIdReceived = (sessionId) {
      widget.onSessionIdReceived!(sessionId);
    };

    widget.crispController.commands.clear();
  }

  @override
  Widget build(BuildContext context) {
    return InAppWebView(
      gestureRecognizers: Set()
        ..add(
          Factory<VerticalDragGestureRecognizer>(
            () => VerticalDragGestureRecognizer(),
          ),
        ),
      initialUrlRequest: URLRequest(
        url: WebUri(
          CrispHelper().crispEmbedUrl(
            websiteId: widget.crispController.websiteId,
            locale: widget.crispController.locale,
            userToken: widget.crispController.userToken,
          ),
        ),
      ),
      initialSettings: _options,
      onWebViewCreated: (InAppWebViewController controller) {
        widget.crispController.webViewController = controller;
      },
      onLoadStop: (InAppWebViewController controller, Uri? url) async {
        widget.crispController.webViewController
            ?.evaluateJavascript(source: _javascriptString!);
        await Future.delayed(const Duration(seconds: 3));
        widget.crispController.getSessionId();
      },
      shouldOverrideUrlLoading: (controller, navigationAction) async {
        var uri = navigationAction.request.url;
        var url = uri.toString();

        if (uri?.host != 'go.crisp.chat') {
          if ([
            "http",
            "https",
            "tel",
            "mailto",
            "file",
            "chrome",
            "data",
            "javascript",
            "about"
          ].contains(uri?.scheme)) {
            if (await canLaunchUrl(Uri.parse(url))) {
              if (widget.onLinkPressed != null) {
                widget.onLinkPressed!(url);
              } else {
                await launchUrl(Uri.parse(url));
              }
              return NavigationActionPolicy.CANCEL;
            }
          }
        }

        return NavigationActionPolicy.ALLOW;
      },
    );
  }
}
