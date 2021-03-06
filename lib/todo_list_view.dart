import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:riverpod_sample/main.dart';
import 'package:riverpod_sample/todo.dart';
import 'package:riverpod_sample/upsert_todo_view.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class Const {
  static const routeNameUpsertTodo = 'upsert-todo';
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primaryColor: Colors.white),
      routes: <String, WidgetBuilder>{
        Const.routeNameUpsertTodo: (BuildContext context) => UpsertTodoView(),
      },
      home: TodoList(),
    );
  }
}

class TodoList extends HookWidget {

  @override
  Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Todo'),
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => _transitionToNextScreen(context),
            ),
          ],
        ),
        body: _buildList(),
      );
  }

  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: const Text('Todo'),
  //       actions: [
  //         IconButton(
  //           icon: const Icon(Icons.add),
  //           onPressed: () => _transitionToNextScreen(context),
  //         ),
  //       ],
  //     ),
  //     body: _buildList(),
  //   );
  // }

  Widget _buildList() {
    final todoState = useProvider(todoViewModelProvider);
    
    return todoState.when(
      data: (value) {
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: value.todoList.length,
          itemBuilder: (BuildContext context, int index) {
            return _dismissible(value.todoList[index], context);
          },
        );
      }, loading: () {
        return Center(
          child: CircularProgressIndicator(),
        );
      }, error: (error, stackTrace) {
        return Text("error");
    });

    // viewModel??????todoList??????/??????
    // final _todoList = todoState.data!.value.todoList;
  }

  Widget _dismissible(Todo todo, BuildContext context) {
    // ListView???swipe????????????widget
    return Dismissible(
      // ???????????????????????????
      key: UniqueKey(),
      confirmDismiss: (direction) async {
        final confirmResult =
        await _showDeleteConfirmDialog(todo.title, context);
        // Future<bool> ???????????????????????????False ???????????????????????????
        return confirmResult;
      },
      onDismissed: (DismissDirection direction) {
        // viewModel???todoList???????????????
        context.read(todoViewModelProvider.notifier).deleteTodo(todo.id);
        // ToastMessage?????????
        Fluttertoast.showToast(
          msg: '${todo.title}?????????????????????',
          backgroundColor: Colors.grey,
        );
      },
      // swipe???ListTile???background
      background: Container(
        alignment: Alignment.centerLeft,
        // background??????/?????????Icon??????
        color: Colors.red,
        child: const Padding(
          padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
          child: Icon(
            Icons.delete,
            color: Colors.white,
          ),
        ),
      ),
      child: _todoItem(todo, context),
    );
  }

  Widget _todoItem(Todo todo, BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(width: 1, color: Colors.grey)),
      ),
      child: ListTile(
        title: Text(
          todo.title,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 16,
          ),
        ),
        onTap: () {
          _transitionToNextScreen(context, todo: todo);
        },
      ),
    );
  }

  Future<void> _transitionToNextScreen(BuildContext context,
      {Todo? todo}) async {
    final result = await Navigator.pushNamed(context, Const.routeNameUpsertTodo,
        arguments: todo);

    if (result != null) {
      // ToastMessage?????????
        await Fluttertoast.showToast(
        msg: result.toString(),
        backgroundColor: Colors.grey,
      );
    }
  }

  Future<bool?> _showDeleteConfirmDialog(
      String title, BuildContext context) async {
    final result = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('??????'),
            content: Text('$title????????????????????????'),
            actions: [
              FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('cancel'),
              ),
              FlatButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('OK'),
              ),
            ],
          );
        });
    return result;
  }

}