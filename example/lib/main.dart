import 'package:crisp_sdk/crisp_sdk.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Crisp',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Crisp Chat Example'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late CrispController crispController;

  @override
  void initState() {
    super.initState();

    crispController = CrispController(
      websiteId: 'your-website-id',
    );

    crispController.register(
      user: CrispUser(
        email: "Amir@provider.com",
        nickname: "Amir Jabbari",
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.logout),
        onPressed: () async {
          crispController.logout();
        },
      ),
      body: Center(
        child: CrispView(
          crispController: crispController,
          clearCache: false,
          onSessionIdReceived: (sessionId) {
            print('------------- sessionIdCrisp  --------------');
            print(sessionId);
          },
        ),
      ),
    );
  }
}
