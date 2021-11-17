import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/modules/archivedTasks/archives_tasks.dart';
import 'package:todo/modules/doneTasks/done_tasks.dart';
import 'package:todo/modules/newTasks/new_tasks.dart';
import 'package:todo/shared/cubit/states.dart';
import 'package:sqflite/sqflite.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(InitialState());
  int index = 0;
  List<Widget> screens = [NewTasks(), DoneTasks(), ArchivedTasks()];
  TextEditingController taskNameController = new TextEditingController();
  TextEditingController taskDateController = new TextEditingController();
  TextEditingController taskTimeController = new TextEditingController();
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];

  AppCubit get(context) => BlocProvider.of(context);
  Database? tasks;

  void bodyWidget(int i) {
    index = i;
    emit(BottomNavigiationState());
  }

  void createTasksDatabase() {
    openDatabase(
      'tasks.db',
      version: 1,
      onCreate: (Database db, int version) {
        // When creating the db, create the table
        db
            .execute(
                'CREATE TABLE tasks (id INTEGER PRIMARY KEY, name TEXT, date TEXT,time TEXT,status TEXT)')
            .then((value) {
          print('table created');
        });
      },
      onOpen: (db) {
        // showDatabaseItems();

      },
      // ).then(
      //   (value) {
      //     print('finished database create');
      //   },
    ).then((value) {tasks = value;
    showDatabaseItems();});
  }

  void insertIntoDatabase() {
    tasks!.transaction((txn) async {
      txn
          .rawInsert(
              'INSERT INTO tasks(name, date, time , status) VALUES("${taskNameController.text}"," ${taskDateController.text}", "${taskTimeController.text}" , "new")')
          .then((value) => print('row no $value inserted'));
    }).then((value) {
      emit(InsertDatabaseItemsState());
      showDatabaseItems();
    });
  }

  void updateDatabase({required int id, required String status}) {
    tasks!.rawUpdate('UPDATE tasks SET status = ? WHERE id = ?',
        ['${status}', id]).then((value) {
      emit(UpdateDatabaseItemsState());
      showDatabaseItems();
    });
  }

  void deleteDatabaseItems({required int id}) {
    tasks!.rawDelete('DELETE FROM tasks WHERE id = ?', [id]).then((value) {
      emit(DeleteDatabaseItemsState());
      showDatabaseItems();
    });
  }

  void showDatabaseItems() {

    tasks!.rawQuery('SELECT * FROM tasks').then((value) {
      newTasks = [];
    doneTasks = [];
    archivedTasks = [];
      value.forEach((element) {
        if (element['status'] == 'new')
          newTasks.add(element);

       else if (element['status'] == 'done')
          doneTasks.add(element);

        else
          archivedTasks.add(element);
      });
        emit(ShowDatabaseItemsState());




    }

    );
  }
}
