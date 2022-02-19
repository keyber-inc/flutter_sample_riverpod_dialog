import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod/riverpod.dart';

final navigatorKeyProvider = Provider(
  (_) => GlobalKey<NavigatorState>(),
);

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      navigatorKey: ref.read(navigatorKeyProvider),
      home: const Home(),
    );
  }
}

class Home extends ConsumerWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final model = ref.read(modelProvider);
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

final modelProvider = ChangeNotifierProvider(
  (ref) => Model(
    navigatorKey: ref.read(navigatorKeyProvider),
  ),
);

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
