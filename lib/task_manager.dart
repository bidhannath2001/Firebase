import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class TaskManager extends StatelessWidget {
  TaskManager({super.key});
  final CollectionReference task = FirebaseFirestore.instance.collection(
    'tasks',
  );
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  Future<void> addTask() async {
    await task.add({
      'title': titleController.text,
      'description': descriptionController.text,
      'isCompleted': false,
    });
    titleController.clear();
    descriptionController.clear();
  }

  Future<void> updateStatus(String id, bool isCompmleted) {
    return task.doc(id).update({'isCompleted': !isCompmleted});
  }

  Future<void> updateTask(String id, bool isCompmleted) {
    return task.doc(id).update({
      'title': titleController.text,
      'description': descriptionController.text,
      'isCompleted': isCompmleted,
    });
  }

  Future<void> deletedTask(String id) {
    return task.doc(id).delete();
  }

  showDialogBox(BuildContext context, [DocumentSnapshot? doc]) {
    if (doc != null) {
      titleController.text = doc['title'];
      descriptionController.text = doc['description'];
    } else {
      titleController.clear();
      descriptionController.clear();
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('${doc != null ? 'Update' : 'Add'} Task'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  labelText: 'Title',
                ),
              ),
              SizedBox(height: 8),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  labelText: 'Description',
                ),
              ),
            ],
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (doc != null) {
                  doc.reference.update({
                    'title': titleController.text,
                    'description': descriptionController.text,
                  });
                } else
                  addTask();
                Navigator.of(context).pop();
              },
              child: Text(doc != null ? 'Update' : 'Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text('Task Manager'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('tasks').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return Center(child: Text("No data found"));
          }
          final task = snapshot.data!.docs;
          return ListView.builder(
            itemCount: task.length,
            itemBuilder: (context, index) {
              final doc = task[index];
              final data = doc.data() as Map<String, dynamic>;
              return Slidable(
                key: ValueKey(doc.id),
                startActionPane: ActionPane(
                  motion: DrawerMotion(),
                  children: [
                    SlidableAction(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      icon: Icons.edit,
                      label: 'Edit',
                      onPressed: (_) {
                        showDialogBox(context, doc);
                      },
                    ),
                  ],
                ),
                endActionPane: ActionPane(
                  motion: DrawerMotion(),
                  children: [
                    SlidableAction(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      icon: Icons.delete,
                      label: 'Delete',
                      onPressed: (_) {
                        deletedTask(doc.id);
                      },
                    ),
                  ],
                ),
                child: Card(
                  elevation: 3,

                  child: ListTile(
                    leading: Checkbox(
                      value: data['isCompleted'],
                      onChanged: (_) {
                        updateStatus(doc.id, data['isCompleted']);
                      },
                    ),
                    title: Text(data['title']),
                    subtitle: Text(data['description']),
                    trailing: Icon(
                      data['isCompleted'] ? Icons.check_circle : null,
                      color: data['isCompleted'] ? Colors.green : Colors.grey,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        onPressed: () {
          showDialogBox(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
