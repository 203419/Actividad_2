import 'package:flutter/material.dart';
import 'package:app_tareas/views/create_task.dart';
import 'package:app_tareas/services/task_methods.dart';
import 'package:app_tareas/model/task.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
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
        automaticallyImplyLeading: false,
        title: const Text('Tareas'),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {});
              uploadTasks();
            },
            icon: const Icon(Icons.refresh),
            color: Colors.white,
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CreateTask(),
            ),
          );
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.green,
      ),

      // cuerpo de la pantalla
      body: Padding(
        padding: const EdgeInsets.all(0),
        child: Column(
          children: [
            StreamBuilder<ConnectivityResult>(
              stream: Connectivity().onConnectivityChanged,
              builder: (BuildContext context,
                  AsyncSnapshot<ConnectivityResult> snapshot) {
                if (snapshot.hasData &&
                    snapshot.data != ConnectivityResult.none) {
                  return SizedBox.shrink();
                } else {
                  return Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(8),
                    color: Colors.red,
                    child: const Text(
                      'No hay conexión a internet',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                      // tamaño de la fuente
                    ),
                  );
                }
              },
            ),
            Expanded(
              child: FutureBuilder(
                future: getTasks(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    final List<Task> tasks = snapshot.data;
                    return ListView.builder(
                      itemCount: tasks.length,
                      itemBuilder: (BuildContext context, int index) {
                        final Task task = tasks[index];

                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 18.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      task.name,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      task.description,
                                      style: const TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () async {
                                await deleteTask(task.id);
                                setState(() {});
                              },
                              icon: const Icon(Icons.delete),
                              color: Colors.red,
                            ),
                            IconButton(
                              color: Colors.blue,
                              icon: const Icon(Icons.edit),
                              onPressed: () async {
                                final TextEditingController nameController =
                                    TextEditingController(text: task.name);
                                final TextEditingController
                                    descriptionController =
                                    TextEditingController(
                                        text: task.description);

                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text('Editar tarea'),
                                        content: Column(
                                          children: <Widget>[
                                            TextField(
                                              controller: nameController,
                                              decoration: const InputDecoration(
                                                hintText: 'Nombre',
                                              ),
                                            ),
                                            TextField(
                                              controller: descriptionController,
                                              decoration: const InputDecoration(
                                                hintText: 'Descripción',
                                              ),
                                            ),
                                          ],
                                        ),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context)
                                                  .pop(); // Cierra el AlertDialog
                                            },
                                            child: const Text('Cancelar'),
                                          ),
                                          TextButton(
                                            onPressed: () async {
                                              final String newName =
                                                  nameController.text;
                                              final String newDescription =
                                                  descriptionController.text;

                                              Task updatedTask = Task(
                                                id: task.id,
                                                name: newName,
                                                description: newDescription,
                                              );

                                              await updateTask(updatedTask);
                                              setState(() {});

                                              Navigator.of(context)
                                                  .pop(); // Cierra el AlertDialog
                                            },
                                            child: const Text('Guardar'),
                                          ),
                                        ],
                                      );
                                    });
                              },
                            ),
                          ],
                        );
                      },
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
