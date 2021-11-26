import 'package:amplify_flutter/amplify.dart';

import 'models/Todo.dart';

class TodoRepository {
  Future<List<Todo>> getTodos() async {
    try {
      final todos = await Amplify.DataStore.query(Todo.classType);
      return todos;
    } catch (e) {
      throw e;
    }
  }

  Future<void> crateTodo(String title) async {
    final newTodo = Todo(title: title, isCompleted: false);
    try {
      await Amplify.DataStore.save(newTodo);
    } catch (e) {
      throw e;
    }
  }

  Future<void> updateTodoIsComplete(Todo todo, bool isComplete) async {
    final updated = todo.copyWith(isCompleted: isComplete);
    try {
      await Amplify.DataStore.save(updated);
    } catch (e) {
      throw e;
    }
  }


}