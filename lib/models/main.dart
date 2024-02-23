import 'dart:collection';

import 'package:crisp_sdk/models/user.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

/// The main model for the [CrispView]
class CrispMain {
  CrispMain({
    required this.websiteId,
    String locale = 'en',
    String? userToken,
    CrispUser? user,
  }) {
    this.locale = locale;
    this.userToken = userToken;
  }

  InAppWebViewController? webViewController;

  /// The id of your crisp chat
  final String websiteId;

  /// Locale to define which language the chat should appear
  String locale = 'en';

  /// The token of the user
  String? userToken;

  /// Commands which are defined on [register] and executed on [CrispView] initState
  Queue commands = Queue<String>();

  /// The chat user model with possible additional data
  CrispUser? user;

  /// Register a new user to start the chat
  void register({required CrispUser user}) {
    if (user.verificationCode != null)
      appendScript("window.\$crisp.push([\"set\", \"user:email\", [\"" +
          user.email +
          "\", \"" +
          user.verificationCode! +
          "\"]])");
    else
      appendScript("window.\$crisp.push([\"set\", \"user:email\", [\"" +
          user.email +
          "\"]])");

    if (user.nickname != null)
      appendScript("window.\$crisp.push([\"set\", \"user:nickname\", [\"" +
          user.nickname! +
          "\"]])");

    if (user.avatar != null)
      appendScript("window.\$crisp.push([\"set\", \"user:avatar\", [\"" +
          user.avatar! +
          "\"]])");

    if (user.phone != null)
      appendScript("window.\$crisp.push([\"set\", \"user:phone\", [\"" +
          user.phone! +
          "\"]])");

    this.user = user;
  }

  setMessage(String text) {
    appendScript(
        "window.\$crisp.push([\"set\", \"message:text\", [\"$text\"]])");
  }

  setSegments(List<String> segments) {
    if (segments.isEmpty) return;

    segments.forEach(
      (value) => appendScript(
          'window.\$crisp.push(["set", "session:segments", [["$value"]]]);'),
    );
  }

  setSessionData(Map<String, String> sessionData) {
    if (sessionData.isEmpty) return;

    sessionData.forEach(
      (key, value) => appendScript(
          'window.\$crisp.push(["set", "session:data", ["$key", "$value"]]);'),
    );
  }

  logout() {
    webViewController?.evaluateJavascript(
        source: "window.\$crisp.push([\"do\", \"session:reset\"])");
  }

  void appendScript(String script) {
    commands.add(script);
  }
}
