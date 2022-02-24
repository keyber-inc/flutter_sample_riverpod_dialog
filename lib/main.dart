import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod/riverpod.dart';

final navigatorKeyProvider = Provider(
  (_) => GlobalKey<NavigatorState>(),
);
final rootScaffoldMessengerKeyProvider = Provider(
  (_) => GlobalKey<ScaffoldMessengerState>(),
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
      scaffoldMessengerKey: ref.read(rootScaffoldMessengerKeyProvider),
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
  (ref) => Model(ref.read),
);

class Model with ChangeNotifier {
  Model(this._reader)
      : navigatorKey = _reader(navigatorKeyProvider),
        scaffoldMessengerKey = _reader(rootScaffoldMessengerKeyProvider);

  final Reader _reader;
  final GlobalKey<NavigatorState> navigatorKey;
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey;

  void push() {
    Navigator.of(navigatorKey.currentContext!).push(
      MaterialPageRoute(
        builder: (context) => const Next(),
      ),
    );
  }

  void showAlertDialog() {
    showDialog(
      context: navigatorKey.currentContext!,
      builder: (context) => const AlertDialog(
        title: Text('Alert Dialog'),
      ),
    );
  }

  void showSnackBar() {
    scaffoldMessengerKey.currentState!.showSnackBar(
      const SnackBar(
        content: Text('SnackBar'),
      ),
    );
  }
}

class Next extends ConsumerWidget {
  const Next({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final model = ref.read(modelProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Next'),
      ),
      body: ListView(
        children: [
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
