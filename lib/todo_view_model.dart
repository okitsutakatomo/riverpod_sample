import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:riverpod_sample/todo.dart';

class TodoViewModel extends ChangeNotifier {

  List<Todo> _todoList = [];
  UnmodifiableListView<Todo> get todoList => UnmodifiableListView(_todoList);

  void createTodo(String title) {
    final id = _todoList.length + 1;
    _todoList = [...todoList, Todo(id, title)];
    notifyListeners();
  }

  void updateTodo(int id, String title) {
    todoList.asMap().forEach((key, value) {
      if (value.id == id) {
        _todoList[key].title = title;
      }
    });
    notifyListeners();
  }

  void deleteTodo(int id) {
    _todoList = _todoList.where((element) => element.id != id).toList();
    notifyListeners();
  }
}