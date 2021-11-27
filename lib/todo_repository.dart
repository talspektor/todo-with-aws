import 'package:amplify_flutter/amplify.dart';

import 'models/Todo.dart';

class TodoRepository {
  Future<List<Todo>> getTodos() async =>
      await Amplify.DataStore.query(Todo.classType).catchError(_onError);

  Future<void> crateTodo(String title) async {
    final newTodo = Todo(title: title, isCompleted: false);
    await Amplify.DataStore.save(newTodo).catchError(_onError);
  }

  Future<void> updateTodoIsComplete(Todo todo, bool isComplete) async {
    final updated = todo.copyWith(isCompleted: isComplete);
    await Amplify.DataStore.save(updated).catchError(_onError);
  }

  Stream observedTodos() {
    return Amplify.DataStore.observe(Todo.classType);
  }

  _onError(Object e) {
    throw e;
  }
}
