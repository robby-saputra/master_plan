import 'package:flutter/material.dart';
import '../models/data_layer.dart';
import '../provider/plan_provider.dart';

class PlanScreen extends StatefulWidget {
  final String planName;
  const PlanScreen({super.key, required this.planName});

  @override
  _PlanScreenState createState() => _PlanScreenState();
}

class _PlanScreenState extends State<PlanScreen> {
  late ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController()
      ..addListener(() {
        FocusScope.of(context).requestFocus(FocusNode());
      });
  }

  @override
  Widget build(BuildContext context) {
    ValueNotifier<List<Plan>> plansNotifier = PlanProvider.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(widget.planName)),
      body: ValueListenableBuilder<List<Plan>>(
        valueListenable: plansNotifier,
        builder: (context, plans, child) {
          final plan = plans.firstWhere((p) => p.name == widget.planName, orElse: () => Plan(name: widget.planName));
          return Column(
            children: [
              Expanded(child: _buildList(plan)),
              SafeArea(child: Text(plan.completenessMessage)),
            ],
          );
        },
      ),
      floatingActionButton: _buildAddTaskButton(context),
    );
  }

  Widget _buildAddTaskButton(BuildContext context) {
    ValueNotifier<List<Plan>> planNotifier = PlanProvider.of(context);
    return FloatingActionButton(
      child: const Icon(Icons.add),
      onPressed: () {
        final plans = planNotifier.value;
        final planIndex = plans.indexWhere((p) => p.name == widget.planName);
        if (planIndex == -1) return;

        final updatedTasks = List<Task>.from(plans[planIndex].tasks)..add(const Task());
        planNotifier.value = List<Plan>.from(plans)
          ..[planIndex] = Plan(
            name: plans[planIndex].name,
            tasks: updatedTasks,
          );
      },
    );
  }

  Widget _buildList(Plan plan) {
    return ListView.builder(
      itemCount: plan.tasks.length,
      itemBuilder: (context, index) {
        return _buildTaskTile(plan, index, context);
      },
    );
  }

  Widget _buildTaskTile(Plan plan, int index, BuildContext context) {
    ValueNotifier<List<Plan>> planNotifier = PlanProvider.of(context);
    final task = plan.tasks[index];

    return ListTile(
      leading: Checkbox(
        value: task.complete,
        onChanged: (selected) {
          final plans = planNotifier.value;
          final planIndex = plans.indexWhere((p) => p.name == widget.planName);
          if (planIndex == -1) return;

          planNotifier.value = List<Plan>.from(plans)
            ..[planIndex] = Plan(
              name: plans[planIndex].name,
              tasks: List<Task>.from(plans[planIndex].tasks)
                ..[index] = Task(
                  description: task.description,
                  complete: selected ?? false,
                ),
            );
        },
      ),
      title: TextFormField(
        initialValue: task.description,
        onChanged: (text) {
          final plans = planNotifier.value;
          final planIndex = plans.indexWhere((p) => p.name == widget.planName);
          if (planIndex == -1) return;

          planNotifier.value = List<Plan>.from(plans)
            ..[planIndex] = Plan(
              name: plans[planIndex].name,
              tasks: List<Task>.from(plans[planIndex].tasks)
                ..[index] = Task(
                  description: text,
                  complete: task.complete,
                ),
            );
        },
      ),
    );
  }
}
