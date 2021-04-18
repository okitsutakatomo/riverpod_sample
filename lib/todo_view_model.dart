import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_sample/todo.dart';
import 'package:riverpod_sample/todo_state.dart';
import 'package:state_notifier/state_notifier.dart';

class TodoViewModel extends StateNotifier<AsyncValue<TodoState>> {
  TodoViewModel() : super(const AsyncValue.data(const TodoState()));

  Future<void> createTodo(String title) async {
    final beforeValue = state.data!.value.copyWith();
    state = const AsyncValue.loading();
    await new Future.delayed(new Duration(seconds: 3));
    final id = beforeValue.todoList.length + 1;
    final newList = [...beforeValue.todoList, Todo(id, title)];
    state = AsyncValue.data(beforeValue.copyWith(todoList: newList));
  }

  Future<void> updateTodo(int id, String title) async {
    final beforeValue = state.data!.value.copyWith();
    state = const AsyncValue.loading();
    await new Future.delayed(new Duration(seconds: 3));
    final newList = beforeValue.todoList
        .map((todo) => todo.id == id ? Todo(id, title) : todo)
        .toList();
    state = AsyncValue.data(beforeValue.copyWith(todoList: newList));
  }

  Future<void> deleteTodo(int id) async {
    await new Future.delayed(new Duration(seconds: 3));
    final newList = state.data!.value.todoList.where((todo) => todo.id != id).toList();
    state = AsyncValue.data(state.data!.value.copyWith(todoList: newList));
  }

  @override
  void dispose() {
    print("dispose");
    super.dispose();
  }
}