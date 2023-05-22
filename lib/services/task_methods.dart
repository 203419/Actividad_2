import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:app_tareas/model/task.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

final String apiUrl = "http://10.0.2.2:3000/tasks/";

Future<bool> checkInternet() async {
  final connectivity = await Connectivity().checkConnectivity();
  if (connectivity == ConnectivityResult.none) {
    return false;
  }
  return true;
}

Future<Task> createTask(Task task) async {
  if (await checkInternet()) {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(task.toJson()),
    );

    if (response.statusCode == 201) {
      final Map<String, dynamic> taskJson = jsonDecode(response.body);
      return Task.fromJson(taskJson);
    } else {
      throw Exception('Error al crear la tarea');
    }
  } else {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> tasks = prefs.getStringList('tasks') ?? [];
    tasks.add(jsonEncode(task.toJson()));
    prefs.setStringList('tasks', tasks);
    return task;
  }
}

Future<List<Task>> getTasks() async {
  if (await checkInternet()) {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final List<dynamic> tasksJson = jsonDecode(response.body);
      return tasksJson.map((json) => Task.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener las tareas');
    }
  } else {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> tasks = prefs.getStringList('tasks') ?? [];
    return tasks.map((json) => Task.fromJson(jsonDecode(json))).toList();
  }
}

Future<void> deleteTask(int id) async {
  final response = await http.delete(Uri.parse(apiUrl + id.toString()));

  if (response.statusCode != 201) {
    throw Exception('Error al eliminar la tarea');
  }
}

Future<void> updateTask(Task task) async {
  final response = await http.patch(
    Uri.parse(apiUrl + task.id.toString()),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(task.toJson()),
  );

  if (response.statusCode != 200) {
    throw Exception('Error al actualizar la tarea');
  }
}

Future<void> uploadTasks() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String> tasks = prefs.getStringList('tasks') ?? [];
  for (String task in tasks) {
    await createTask(Task.fromJson(jsonDecode(task)));
  }
  prefs.setStringList('tasks', []);
}
