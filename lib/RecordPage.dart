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
    return Column(
      children : [
        Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children : [
              Container(
                height: cardSizeSmall,
                width: cardSizeRegular,
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
                  children : [
                    SizedBox(height: 5,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        //Image.asset("assets/img/todo.png", width: 45, height: 45,),
                        Icon(Icons.access_time_rounded),
                        SizedBox(width: 55,),
                        Text("${allTodo.length}", style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold
                        ),),
                      ],
                    ),
                    SizedBox(height: 10,),
                    Text("TODO", style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold)
                    ),
                  ], 
                ),
              ),
              SizedBox(width: 15,),
              Container(
                height: cardSizeSmall,
                width: cardSizeRegular,
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
                  children : [
                    SizedBox(height: 5,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add_chart_rounded),
                        SizedBox(width: 55,),
                        Text("${allTodo.length}", style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold
                        ),),
                      ],
                    ),
                    SizedBox(height: 10,),
                    Text("전체", style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold)
                    ),
                  ],
                ),
              ),
            ]
        ),
        Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children : [
              Container(
                height: cardSizeSmall,
                width: cardSizeRegular,
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
                  children : [
                    SizedBox(height: 5,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add_box_outlined),
                        SizedBox(width: 55,),
                        Text("${allTodo.length}", style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold
                        ),),
                      ],
                    ),
                    SizedBox(height: 10,),
                    Text("미완료", style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold)
                    ),
                  ],
                ),
              ),
              SizedBox(width: 15,),
              Container(
                height: cardSizeSmall,
                width: cardSizeRegular,
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
                  children : [
                    SizedBox(height: 5,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add_box),
                        SizedBox(width: 55,),
                        Text("${allTodo.length}", style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold
                        ),),
                      ],
                    ),
                    SizedBox(height: 10,),
                    Text("완료", style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold)
                    ),
                  ],
                ),
              ),
            ]
        ),
      ],
    );
  }
}
