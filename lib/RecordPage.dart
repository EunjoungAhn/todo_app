import 'package:flutter/material.dart';
import 'package:todo_app/components/app_constants.dart';
import 'package:todo_app/data/todo/todo.dart';
import 'package:todo_app/data/todo/database.dart';

class RecordPage extends StatefulWidget {
  final List<Todo> allTodo;
  const RecordPage({Key key, this.allTodo}) : super(key: key);

  @override
  State<RecordPage> createState() => _RecordPageState();
}

class _RecordPageState extends State<RecordPage> {

  final dbHelper = DatabaseHelper.instance;

  // 전체 기록을 가져오는 리스트
  List<Todo> allTodo = [];

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children : [
          Container(
            height: cardSize,
            width: cardSize,
            margin: EdgeInsets.all(8),
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                      blurRadius: 4,
                      spreadRadius: 4,
                      color: Colors.black12
                  )
                ]
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("${allTodo.length}", style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold
                ),),
              ],
            ),
          ),
          Container(
            height: cardSize,
            width: cardSize,
            margin: EdgeInsets.all(8),
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                      blurRadius: 4,
                      spreadRadius: 4,
                      color: Colors.black12
                  )
                ]
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("${allTodo.length}", style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold
                ),),
              ],
            ),
          ),
        ]
      ),
      height: cardSize,
      width: cardSize,
    );
  }
}
