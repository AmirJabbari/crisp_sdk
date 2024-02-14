# Crisp SDK Dart Package

This package provides a Dart interface for the Crisp chat SDK.

## Features

- Set user details such as email, nickname, avatar, and phone number.
- Register a new user to start the chat.
- Set a message text.
- Set user segments.
- Set session data.

## Usage

First, import the package:

```dart
import 'package:crisp_sdk/models/user.dart';
```

Then, create a CrispMain object:

```dart
CrispMain crispMain = CrispMain(
  websiteId: 'your_website_id',
  locale: 'en',
  userToken: 'user_token',
);
```

```dart
  @override
Widget build(BuildContext context) {
  return CrispView(
    crispMain: crispMain,
    clearCache: true,
    onSessionIdReceived: (sessionId) {
      print('------------- sessionIdCrisp  --------------');
      print(sessionId);
    },
  );
}
}

```

You can set user details using the register method:

```dart
crispMain.register(
  user: CrispUser(
    email: 'user_email',
    nickname: 'user_nickname',
    avatar: 'user_avatar_url',
    phone: 'user_phone_number',
  ),
);
```

You can set a message text using the setMessage method:

```dart
crispMain.setMessage('Hello, world!');
```
You can set user segments using the setSegments method:
```dart
crispMain.setSegments(['segment1', 'segment2']);
```
You can set session data using the setData method:
```dart
crispMain.setData({'key1': 'value1', 'key2': 'value2'});
```

Contributing
Contributions are welcome! Please read our contributing guidelines to get started.

License
This project is licensed under the terms of the MIT license. See the LICENSE file for details.