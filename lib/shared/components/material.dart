import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todo/shared/cubit/cubit.dart';
import 'package:todo/shared/cubit/states.dart';

Widget defaultButton(
    {required String text, required void Function() onPressed}) {
  return (OutlinedButton(
    onPressed: onPressed,
    child: Text(text),
  ));
}

Widget defaultTextBox(
    {required TextEditingController controller,
    bool obscureText = false,
    bool readOnly = false,
    required String labelText,
    required Icon icon,
    String? hintText,
    required String? Function(String?)? validator,
    void Function()? onTap}) {
  return (TextFormField(
    onTap: onTap,
    validator: validator,
    decoration: InputDecoration(
      labelText: labelText,
      icon: icon,
      hintText: hintText,
    ),
    controller: controller,
    obscureText: obscureText,
    readOnly: readOnly,
  ));
}

Widget defaultTaskItem({required Map item, required context}) {
  return Container(
    key: Key(item['id'].toString()),
    margin: EdgeInsets.all(1),
    width: double.infinity,
    child: (Card(
        elevation: 7,
        child: Slidable(
          // key: item['id'],
          startActionPane: ActionPane(
            motion: BehindMotion(),
            children: [
              SizedBox(width: 10),
              IconButton(
                icon: Icon(
                  Icons.delete_forever_outlined,
                  size: 38,
                  color: Colors.lightBlueAccent,
                ),
                onPressed: () {
                  AppCubit().get(context).deleteDatabaseItems(id: item['id']);
                },
              ),
            ],
          ),
          endActionPane: ActionPane(
            motion: ScrollMotion(),
            children: [
              SizedBox(width: 10),
              IconButton(
                icon: Icon(
                  Icons.done_outline,
                  size: 38,
                  color: Colors.lightBlueAccent,
                ),
                onPressed: () {
                  AppCubit()
                      .get(context)
                      .updateDatabase(id: item['id'], status: 'done');
                },
              ),
              SizedBox(width: 10),
              IconButton(
                icon: Icon(
                  Icons.archive_outlined,
                  size: 38,
                  color: Colors.lightBlueAccent,
                ),
                onPressed: () {
                  AppCubit()
                      .get(context)
                      .updateDatabase(id: item['id'], status: 'archived');
                },
              ),
            ],
          ),
          child: Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Row(
                // mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    radius: 30,
                    child: Text('${item['id']}'),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          '${item['name']}',
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        Text('${item['date']}', style: TextStyle(fontSize: 17)),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  (Text('${item['time']}',
                      style: TextStyle(
                          fontSize: 17, fontWeight: FontWeight.bold))),
                  SizedBox(
                    width: 10,
                  )
                ],
              ),
            ),
          ),
        ))),
  );
}

Widget defaultTaskMenu({required List<Map> theList}) {
  return (ListView.builder(
      itemCount: theList.length,
      itemBuilder: (context, index) {
        return (defaultTaskItem(item: theList[index], context: context
            // key: AppCubit().get(context).newTasks[index]['id']

            ));
      }));
}
