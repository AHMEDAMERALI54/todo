import 'package:flutter/material.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/shared/components/material.dart';
import 'package:todo/shared/cubit/cubit.dart';
import 'package:todo/shared/cubit/states.dart';
import 'package:intl/intl.dart';

class MainMenu extends StatelessWidget {
  // const MainMenu({Key? key}) : super(key: key);
  var scaffoldkey = GlobalKey<ScaffoldState>();
  var formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return (BlocProvider(
      create: (context) => AppCubit()..createTasksDatabase(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            key: scaffoldkey,
            appBar: AppBar(
              title: const Text("بسم الله الرحمن الرحيم"),
              actions: [
                IconButton(
                    onPressed: () {
                      scaffoldkey.currentState!.showBottomSheet((context) {
                        return (SafeArea(
                            child: Form(
                          key: formkey,
                          child: Card(
                            elevation: 12,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                defaultTextBox(
                                  controller: AppCubit()
                                      .get(context)
                                      .taskNameController,
                                  labelText: 'Taskname',
                                  icon: Icon(Icons.drive_file_rename_outline),
                                  validator: (v) {
                                    if (v.toString().isEmpty) {
                                      return ('please enter task name');
                                    }
                                    return (null);
                                  },
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                defaultTextBox(
                                  controller: AppCubit()
                                      .get(context)
                                      .taskDateController,
                                  readOnly: true,
                                  onTap: () {
                                    showDatePicker(
                                            context: context,
                                            initialDate: DateTime(
                                                DateTime.now().year,
                                                DateTime.now().month,
                                                DateTime.now().day),
                                            firstDate: DateTime(
                                                DateTime.now().year,
                                                DateTime.now().month,
                                                DateTime.now().day),
                                            lastDate: DateTime(
                                                DateTime.now().year,
                                                DateTime.now().month + 1,
                                                DateTime.now().day + 10))
                                        .then((value) => AppCubit()
                                                .get(context)
                                                .taskDateController
                                                .text =
                                            DateFormat.yMMMd()
                                                .format(value!)
                                                .toString());
                                  },
                                  labelText: 'task date',
                                  icon: Icon(Icons.date_range_outlined),
                                  validator: (v) {
                                    if (v.toString().isEmpty) {
                                      return ('please enter task date');
                                    }
                                    return (null);
                                  },
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                defaultTextBox(
                                  controller: AppCubit()
                                      .get(context)
                                      .taskTimeController,
                                  readOnly: true,
                                  onTap: () {
                                    showTimePicker(
                                            context: context,
                                            initialTime: TimeOfDay.now())
                                        .then((value) {
                                      AppCubit()
                                              .get(context)
                                              .taskTimeController
                                              .text =
                                          value!.format(context).toString();
                                      print(value);
                                    });
                                  },
                                  labelText: 'Task time',
                                  icon: Icon(Icons.access_time),
                                  validator: (v) {
                                    if (v.toString().isEmpty) {
                                      return ('please enter task time');
                                    }
                                    return (null);
                                  },
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                defaultButton(
                                    text: 'add the task', onPressed: () {
                                      if(formkey.currentState!.validate()){
                                        AppCubit().get(context).insertIntoDatabase();
                                        Navigator.pop(context);
                                        // formkey.currentState!.reset();
                                      }
                                }),
                                SizedBox(
                                  height: 25,
                                ),
                              ],
                            ),
                          ),
                        )));
                      });
                    },
                    icon: Icon(
                      (Icons.add_circle_outline),
                      size: 35,
                    )),
                SizedBox(
                  width: 10,
                )
              ],
            ),
            body: SafeArea(
                child: AppCubit()
                    .get(context)
                    .screens[AppCubit().get(context).index]),
            bottomNavigationBar: ConvexAppBar(
              items: const [
                TabItem(icon: Icons.task_outlined, title: 'New Task'),
                TabItem(icon: Icons.done_outline_sharp, title: 'done'),
                TabItem(icon: Icons.archive_outlined, title: 'archive'),
              ],
              initialActiveIndex: 0, //optional, default as 0
              onTap: (int i) {
                AppCubit().get(context).bodyWidget(i);
              },
            ),
          );
        },
      ),
    ));
  }
}
