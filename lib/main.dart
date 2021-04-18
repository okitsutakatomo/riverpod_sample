import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_sample/todo_list_view.dart';
import 'package:riverpod_sample/todo_state.dart';
import 'package:riverpod_sample/todo_view_model.dart';

final todoViewModelProvider = StateNotifierProvider.autoDispose<TodoViewModel, AsyncValue<TodoState>>(
      (ref) => TodoViewModel(),
);

void main() {

  const state1 = TodoState();
  var state2 = state1.copyWith();
  const state3 = TodoState();

  if (state1 == state2) {
    print("Equals1");
  }

  if (state2 == state3) {
    print("Equals2");
  }

  print(identical(state1, state1));
  print(identical(state1, state2));
  print(state2.hashCode);
  print(state3.hashCode);

  runApp(
      ProviderScope(
        child: MyApp()
      )
  );
}