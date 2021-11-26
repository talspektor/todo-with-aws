import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/todo_repository.dart';

import 'models/Todo.dart';

abstract class TodoState {}

class LoadingTodos extends TodoState {}

class ListTodosSuccess extends TodoState {
  final List<Todo> todos;

  ListTodosSuccess({required this.todos});
}

class ListTodosFailure extends TodoState {
  final Exception exception;

  ListTodosFailure({required this.exception});
}

class TodoCubit extends Cubit<dynamic> {
  final _todoRepository = TodoRepository();

  TodoCubit() : super(LoadingTodos());

  getTodos() async {
    if (state is ListTodosSuccess == false) {
      emit(LoadingTodos());
    }
    await _todoRepository
        .getTodos()
        .then(_handleSuccess)
        .catchError(_handleError);
  }

  _handleSuccess(List<Todo> todos) {
    emit(ListTodosSuccess(todos: todos));
  }

  _handleError(Object e) {
    if (e is Exception) {
      emit(ListTodosFailure(exception: e));
    }
  }

  crateTodo(String title) async {
    await _todoRepository.crateTodo(title);
    getTodos();
  }

  updateTodoIsComplete(Todo todo, bool isComplete) async {
    await _todoRepository.updateTodoIsComplete(todo, isComplete);
    getTodos();
  }
}
