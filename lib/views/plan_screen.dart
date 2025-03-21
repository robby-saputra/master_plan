import '../models/data_layer.dart';
import 'package:flutter/material.dart';

class PlanScreen extends StatefulWidget {
  const PlanScreen({super.key});

  @override
  State createState() => _PlanScreenState();
}

class _PlanScreenState extends State<PlanScreen> {
  Plan plan = Plan(); // Hapus const agar bisa dimodifikasi

  Widget _buildAddTaskButton() {
    return FloatingActionButton(
      child: const Icon(Icons.add),
      onPressed: () {
        setState(() {
          plan = Plan(
            name: plan.name,
            tasks: [...plan.tasks, const Task()], // Menggunakan spread operator
          );
        });
      },
    );
  }

  Widget _buildTaskTile(Task task, int index) {
    return ListTile(
      leading: Checkbox(
        value: task.complete,
        onChanged: (selected) {
          setState(() {
            plan = Plan(
              name: plan.name,
              tasks: [
                ...plan.tasks.sublist(0, index),
                Task(description: task.description, complete: selected ?? false),
                ...plan.tasks.sublist(index + 1),
              ],
            );
          });
        },
      ),
      title: TextFormField(
        initialValue: task.description,
        onChanged: (text) {
          setState(() {
            plan = Plan(
              name: plan.name,
              tasks: [
                ...plan.tasks.sublist(0, index),
                Task(description: text, complete: task.complete),
                ...plan.tasks.sublist(index + 1),
              ],
            );
          });
        },
      ),
    );
  }

  Widget _buildList() {
    return ListView.builder(
      itemCount: plan.tasks.length,
      itemBuilder: (context, index) {
        return _buildTaskTile(plan.tasks[index], index);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Master Plan Robby')),
      body: _buildList(),
      floatingActionButton: _buildAddTaskButton(),
    );
  }
}
