import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/todo_cubit.dart';
import 'package:todo/todo_repository.dart';
import 'package:todo/todos_view.dart';

import 'amplifyconfiguration.dart';
import 'loading_view.dart';
import 'models/ModelProvider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  bool _amplifyConfigured = false;

  @override
  void initState() {
    super.initState();
    _configureAmplify();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MultiBlocProvider(providers: [
        BlocProvider(
          create: (context) => TodoCubit()..getTodos(),
        ),
      ], child: _amplifyConfigured ? const TodosView() : const LoadingView()),
    );
  }

  void _configureAmplify() async {
    // Once Plugins are added, configure Amplify

    try {
      await Future.wait([
        Amplify.addPlugin(
            AmplifyDataStore(modelProvider: ModelProvider.instance)),
        // Amplify.addPlugin(AmplifyAPI())
      ]);
      await Amplify.configure(amplifyconfig);
      setState(() {
        _amplifyConfigured = true;
      });
    } catch (e) {
      print(e);
    }
  }
}
