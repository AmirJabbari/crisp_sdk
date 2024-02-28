import 'dart:collection';

import 'package:crisp_sdk/models/user.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

/// The controller to manage the chat
class CrispController {
  CrispController({
    required this.websiteId,
    this.locale = 'en',
    this.userToken,
    CrispUser? user,
    this.onSessionIdReceived,
  });

  /// A callback that is invoked when the session id is received.
  void Function(String sessionId)? onSessionIdReceived;

  /// The web view controller
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
  /// This is useful to register a new user to start the chat.
  void register({required CrispUser user}) {
    if (user.verificationCode != null) {
      appendScript(
          "window.\$crisp.push([\"set\", \"user:email\", [\"${user.email}\", \"${user.verificationCode!}\"]])");
    } else {
      appendScript(
          "window.\$crisp.push([\"set\", \"user:email\", [\"${user.email}\"]])");
    }

    if (user.nickname != null) {
      appendScript(
          "window.\$crisp.push([\"set\", \"user:nickname\", [\"${user.nickname!}\"]])");
    }

    if (user.avatar != null) {
      appendScript(
          "window.\$crisp.push([\"set\", \"user:avatar\", [\"${user.avatar!}\"]])");
    }

    if (user.phone != null) {
      appendScript(
          "window.\$crisp.push([\"set\", \"user:phone\", [\"${user.phone!}\"]])");
    }

    this.user = user;
  }

  /// Set Initial Message
  /// This is useful to set the initial message.
  setMessage(String text) {
    appendScript(
        "window.\$crisp.push([\"set\", \"message:text\", [\"$text\"]])");
  }

  setSegments(List<String> segments) {
    if (segments.isEmpty) return;

    for (var value in segments) {
      appendScript(
          'window.\$crisp.push(["set", "session:segments", [["$value"]]]);');
    }
  }

  /// Set the session data
  /// This is useful to set the session data.
  /// It will set the session data for the user's session.
  /// It will also set the session data for the user's session.
  setSessionData(Map<String, String> sessionData) {
    if (sessionData.isEmpty) return;

    sessionData.forEach(
      (key, value) => appendScript(
          'window.\$crisp.push(["set", "session:data", ["$key", "$value"]]);'),
    );
  }

  /// Logout the user from the chat
  /// This is useful to logout the user from the chat.
  /// It will reset the user's session.
  /// It will also clear the user's data.
  /// It will also clear the user's segments.
  /// It will also clear the user's session data.
  logout() {
    webViewController?.evaluateJavascript(
        source: "window.\$crisp.push([\"do\", \"session:reset\"])");
    getSessionId();
  }

  /// Get the session id
  /// This is useful to track the user's session.
  /// The session id is a unique identifier for the user's session.
  /// The session id is received in the [onSessionIdReceived] callback.
  /// If the session id is not received, it will try to get the session id again.
  /// If the session id is not found, it will return 'Session ID not found'.
  /// If the session id is found, it will return the session id.
  /// If the session id is found and the [onSessionIdReceived] callback is not null, it will invoke the [onSessionIdReceived] callback.
  Future<String> getSessionId() async {
    String? sessionId = await webViewController?.evaluateJavascript(
        source: 'window.\$crisp.get("session:identifier")');
    if (sessionId != null && onSessionIdReceived != null) {
      onSessionIdReceived!(sessionId);
      return sessionId;
    }
    if (sessionId == null) getSessionId();
    return sessionId ?? 'Session ID not found';
  }

  /// Append a script to the queue
  /// This is useful to append a script to the queue and execute it on [CrispView] initState
  void appendScript(String script) {
    commands.add(script);
  }
}
