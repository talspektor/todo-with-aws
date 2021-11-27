import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/auth_cubit.dart';
import 'package:todo/auth_state.dart';
import 'package:todo/auth_view.dart';
import 'package:todo/loading_view.dart';
import 'package:todo/todo_cubit.dart';
import 'package:todo/todos_view.dart';

class AppNavigator extends StatelessWidget {
  const AppNavigator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
        bloc: context.read<AuthCubit>(),
        builder: (context, state) {
          return Navigator(
            pages: [
              if (state is Unauthenticated)
                const MaterialPage(child: AuthView()),
              if (state is Authenticated) _todosViewPage(userId: state.userId),
              if (state is UnKnownAuthState)
                const MaterialPage(child: LoadingView()),
            ],
            onPopPage: (route, result) => route.didPop(result),
          );
        });
  }

  MaterialPage _todosViewPage({required String userId}) => MaterialPage(
        child: BlocProvider(
          create: (context) => TodoCubit(userId: userId)
            ..getTodos()
            ..observeTodos(),
          child: const TodosView(),
        ),
      );
}
