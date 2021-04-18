import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:riverpod_sample/main.dart';
import 'package:riverpod_sample/todo.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class UpsertTodoView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Todo? todo = ModalRoute.of(context)!.settings.arguments as Todo?;
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo${todo == null ? '作成' : '更新'}'),
      ),
      body: TodoForm(),
    );
  }
}

class TodoForm extends HookWidget {
  final _formKey = GlobalKey<FormState>();
  String _title = '';

  @override
  Widget build(BuildContext context) {
    // state.when(data: (data) {
    //   print(data.todoList.length);
    // }, loading: () {

    // }, error: (error, stackTrace){

    // });

    final isLoading = useProvider(todoViewModelProvider.select((value) => value.data == AsyncValue.loading().data));

    final Todo? todo = ModalRoute.of(context)!.settings.arguments as Todo?;
    return LoadingOverlay(
      child: Form(
      key: _formKey,
      child: Container(
        padding: const EdgeInsets.all(64),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TextFormField(
              initialValue: todo != null ? todo.title : '',
              maxLength: 20,
              maxLengthEnforced: true,
              decoration: const InputDecoration(
                hintText: 'Todoタイトルを入力してください',
                labelText: 'Todoタイトル',
              ),
              validator: (title) {
                return title != null && title.isEmpty ? 'Todoタイトルを入力してください' : null;
              },
              onSaved: (title) {
                _title = title!;
              },
            ),
            ElevatedButton(
              onPressed: () => _submission(context, todo),
              child: Text('Todoを${todo == null ? '作成' : '更新'}する'),
            ),
          ],
        ),
      ),
    ), isLoading: isLoading);
  }

  void _submission(BuildContext context, Todo? todo) {
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if (todo != null) {
        // viewModelのtodoListを更新
        context.read(todoViewModelProvider.notifier).updateTodo(todo.id, _title).then((value) {
          Navigator.pop(context, '$_titleを${todo == null ? '作成' : '更新'}しました');
        });
      } else {
        // viewModelのtodoListを作成
        context.read(todoViewModelProvider.notifier).createTodo(_title).then((value) {
          // 前の画面に戻る
          Navigator.pop(context, '$_titleを${todo == null ? '作成' : '更新'}しました');
        });
      }
    }
  }
}
