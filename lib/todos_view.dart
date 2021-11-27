import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/auth_cubit.dart';
import 'package:todo/loading_view.dart';
import 'package:todo/models/Todo.dart';
import 'package:todo/todo_cubit.dart';

class TodosView extends StatefulWidget {
  const TodosView({Key? key}) : super(key: key);

  @override
  _TodosViewState createState() => _TodosViewState();
}

class _TodosViewState extends State<TodosView> {
  final _titleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _navBar(),
      floatingActionButton: _floatingActionButton(),
      body: BlocBuilder(
        bloc: context.read<TodoCubit>(),
        builder: (context, state) {
          if (state is ListTodosSuccess) {
            return state.todos.isEmpty
                ? _emptyTodosView()
                : _todosListView(state.todos);
          } else if (state is ListTodosFailure) {
            return _exceptionView(state.exception);
          } else {
            return const LoadingView();
          }
        },
      ),
    );
  }

  Widget _todosListView(List<Todo> todos) {
    return ListView.builder(
      itemCount: todos.length,
      itemBuilder: (context, index) {
        final todo = todos[index];
        return Card(
          child: CheckboxListTile(
            title: Text(todo.title),
            value: todo.isCompleted,
            onChanged: (newValue) {
              if (newValue != null) {
                context.read<TodoCubit>().updateTodoIsComplete(todo, newValue);
              }
            },
          ),
        );
      },
    );
  }

  Widget _exceptionView(Exception exception) {
    return Center(
      child: Text(exception.toString()),
    );
  }

  AppBar _navBar() {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.logout),
        onPressed: () =>
            BlocProvider.of<AuthCubit>(context).attemptAutoSignIn(),
      ),
      title: const Text('Todos'),
    );
  }

  Widget _newTodoListView() {
    return Column(
      children: [
        TextField(
          controller: _titleController,
          decoration: const InputDecoration(hintText: 'Enter todo title'),
        ),
        ElevatedButton(
          onPressed: _createNewToDo,
          child: const Text('Save Todo'),
        )
      ],
    );
  }

  _createNewToDo() {
    context.read<TodoCubit>().crateTodo(_titleController.text);
    _titleController.text = '';
    Navigator.of(context).pop();
  }

  Widget _floatingActionButton() {
    return FloatingActionButton(
      onPressed: () {
        showModalBottomSheet(
            context: context, builder: (context) => _newTodoListView());
      },
      child: const Icon(Icons.add),
    );
  }

  Widget _emptyTodosView() {
    return const Center(
      child: Text('No todos yet'),
    );
  }
}
