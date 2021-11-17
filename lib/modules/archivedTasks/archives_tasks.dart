import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/shared/components/material.dart';
import 'package:todo/shared/cubit/cubit.dart';
import 'package:todo/shared/cubit/states.dart';

class ArchivedTasks extends StatelessWidget {
  const ArchivedTasks({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return (BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return (AppCubit().get(context).archivedTasks.isNotEmpty
              ? defaultTaskMenu(theList: AppCubit().get(context).archivedTasks)
              : const Center(
                  child: Text(
                    'no tasks  here.. ',
                    style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        overflow: TextOverflow.fade),
                  ),
                ));
        }));
  }
}
