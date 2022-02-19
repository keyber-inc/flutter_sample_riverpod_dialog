import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

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
    return const MaterialApp(
      home: Home(),
    );
  }
}

class Home extends ConsumerWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final model = ref.read(modelProvider);
    return StreamBuilder<String>(
      stream: model.event,
      builder: (context, snapshot) {
        WidgetsBinding.instance?.addPostFrameCallback((_) {
          _handleEvent(context, snapshot.data);
        });
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
      },
    );
  }

  void _handleEvent(BuildContext context, String? event) {
    print('receive: $event');
    switch (event) {
      case 'push':
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => Scaffold(
              appBar: AppBar(
                title: const Text('Next Page'),
              ),
            ),
          ),
        );
        break;

      case 'showAlertDialog':
        showDialog(
          context: context,
          builder: (context) => const AlertDialog(
            title: Text('Alert Dialog'),
          ),
        );
        break;

      case 'showSnackBar':
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('SnackBar'),
          ),
        );
        break;
    }
  }
}

final modelProvider = ChangeNotifierProvider(
  (ref) => Model(),
);

class Model with ChangeNotifier {
  Model();

  final _streamController = StreamController<String>.broadcast();
  Stream<String> get event => _streamController.stream;

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }

  void push() {
    _streamController.sink.add('push');
  }

  void showAlertDialog() {
    _streamController.sink.add('showAlertDialog');
  }

  void showSnackBar() {
    _streamController.sink.add('showSnackBar');
  }
}
