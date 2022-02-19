import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      Provider(create: (_) => GlobalKey<NavigatorState>()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: context.read(),
      home: ChangeNotifierProvider(
        create: (context) => Model(
          navigatorKey: context.read(),
        ),
        child: const Home(),
      ),
    );
  }
}

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.watch<Model>();
    return Scaffold(
      key: model.scaffoldKey,
      appBar: AppBar(
        title: const Text('Sample'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Navigation'),
            onTap: model.push,
          ),
          ListTile(
            title: const Text('Alert Dialog'),
            onTap: model.showAlertDialog,
          ),
          ListTile(
            title: const Text('SnackBar'),
            onTap: model.showSnackBar,
          ),
        ],
      ),
    );
  }
}

class Model with ChangeNotifier {
  Model({
    required this.navigatorKey,
  });

  final GlobalKey<NavigatorState> navigatorKey;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  void push() {
    Navigator.of(navigatorKey.currentContext!).push(
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: const Text('Next Page'),
          ),
        ),
      ),
    );
  }

  void showAlertDialog() {
    showDialog(
      context: scaffoldKey.currentContext!,
      builder: (context) => const AlertDialog(
        title: Text('Alert Dialog'),
      ),
    );
  }

  void showSnackBar() {
    ScaffoldMessenger.of(scaffoldKey.currentContext!).showSnackBar(
      const SnackBar(
        content: Text('SnackBar'),
      ),
    );
  }
}
