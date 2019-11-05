import 'package:flutter/material.dart';
import 'package:todoapp/bloc/blocs/user_bloc_provider.dart';
import 'package:todoapp/models/classes/task.dart';
import 'package:todoapp/models/global.dart';
import 'package:todoapp/models/widgets/intray_todo_widget.dart';

class IntrayPage extends StatefulWidget {
  final String apiKey;
  IntrayPage({this.apiKey});
  @override
  _IntrayPageState createState() => _IntrayPageState();
}

class _IntrayPageState extends State<IntrayPage> {
  List<Task> taskList = [];
  TaskBloc tasksBloc;

  @override
  void initState() {
    tasksBloc = TaskBloc(widget.apiKey);
  }
  @override
  void dispose() {
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
        color: darkGreyColor,
        child: StreamBuilder( // Wrap our widget with a StreamBuilder
          stream: tasksBloc.getTasks, // pass our Stream getter here
          initialData: [], // provide an initial data
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot != null) {
                  if (snapshot.data.length > 0) {
                    return _buildReorderableListSimple(context, snapshot.data);
                  }
                  else if (snapshot.data.length==0){
                    return Center(child: Text('No Data'));
                  }
                } else if (snapshot.hasError) {
                  return Container();
                }
                return CircularProgressIndicator();
            }, // access the data in our Stream here
        )
        // child: ReorderableListView(∆
        //   padding: EdgeInsets.only(top: 300),
        //   children: todoItems,
        //   onReorder: _onReorder,
        // ),
        );
  }

  Widget _buildListTile(BuildContext context, Task item) {
    return ListTile(
      key: Key(item.taskId.toString()),
      title: IntrayTodo(
        title: item.title,
      ),
    );
  }

  Widget _buildReorderableListSimple(
    BuildContext context, List<Task> taskList) {
    return Theme(
      data: ThemeData(canvasColor: Colors.transparent),
      child: ReorderableListView(
        // handleSide: ReorderableListSimpleSide.Right,
        // handleIcon: Icon(Icons.access_alarm),
        padding: EdgeInsets.only(top: 300.0),
        children:
            taskList.map((Task item) => _buildListTile(context, item)).toList(),
        onReorder: (oldIndex, newIndex) {
          setState(() {
            Task item = taskList[oldIndex];
            taskList.remove(item);
            taskList.insert(newIndex, item);
          });
        },
      ),
    );
  }

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final Task item = taskList.removeAt(oldIndex);
      taskList.insert(newIndex, item);
    });
  }

  // Future<List<Task>> getList() async {
  //   List<Task> tasks = await tasksBloc.getUserTasks(widget.apiKey);
  //   return tasks;
  // }
}
