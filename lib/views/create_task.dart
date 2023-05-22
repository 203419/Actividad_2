import 'package:flutter/material.dart';
import 'package:app_tareas/services/task_methods.dart';
import 'package:app_tareas/model/task.dart';
import 'package:app_tareas/home.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class CreateTask extends StatefulWidget {
  const CreateTask({Key? key}) : super(key: key);

  @override
  State<CreateTask> createState() => _CreateTask();
}

class _CreateTask extends State<CreateTask> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _idController = TextEditingController();

  Future<bool> checkInternet() async {
    final connectivity = await Connectivity().checkConnectivity();
    if (connectivity == ConnectivityResult.none) {
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear tarea'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                hintText: 'Nombre',
              ),
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                hintText: 'Descripción',
              ),
            ),
            TextField(
              controller: _idController,
              decoration: const InputDecoration(
                hintText: 'Id',
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                final String name = _nameController.text;
                final String description = _descriptionController.text;
                final int id = int.parse(_idController.text);

                final Task task = await createTask(
                  Task(
                    id: id,
                    name: name,
                    description: description,
                  ),
                );

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Tarea creada con id: ${task.id}',
                    ),
                  ),
                );
                // regresar a la pantalla anterior
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Home(),
                  ),
                );
              },
              child: const Text('Crear tarea'),
            ),
          ],
        ),
      ),
    );
  }
}
