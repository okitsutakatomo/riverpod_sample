import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_sample/todo.dart';
import 'package:riverpod_sample/todo_list_view.dart';
import 'package:riverpod_sample/todo_view_model.dart';
import 'package:riverpod_sample/upsert_todo_view.dart';
import 'package:state_notifier/state_notifier.dart';

final todoViewModelProvider = StateNotifierProvider(
      (ref) => TodoViewModel(),
);

void main() {
  runApp(
      ProviderScope(
        child: MyApp()
      )
  );
}