import 'package:flutter/material.dart';
import 'package:todo_app/components/app_constants.dart';
import 'package:todo_app/data/todo/database.dart';
import 'package:todo_app/data/todo/todo.dart';
import 'package:todo_app/data/todo/util.dart';
import 'package:todo_app/main.dart';
import 'package:todo_app/service/allHistory.dart';
import 'package:todo_app/service/doneAllHistroy.dart';
import 'package:todo_app/service/search.dart';
import 'package:todo_app/service/unDoneAllHistroy.dart';

class RecordPage extends StatefulWidget {
  final List<Todo> allTodo;
  const RecordPage({Key key, this.allTodo}) : super(key: key);

  @override
  State<RecordPage> createState() => _RecordPageState();
}

class _RecordPageState extends State<RecordPage> {

  final dbHelper = DatabaseHelper.instance;

  // 오늘 날짜 기준의 투두들을 가져와라
  void getTodayTodo() async {
    todos = await dbHelper.getTodoByDate(Utils.getFormatTime(DateTime.now()));
    setState(() {
      getTodayTodo();
    });
  }

  // 모든 메모들을 가져와라
  void getAllTodo() async {
    allTodo = await dbHelper.getAllTodo();
    setState(() {
      getAllTodo();
    });
  }

  @override
  void initState() {
    getAllTodo();
    super.initState();
  }

  // 전체 기록을 가져오는 리스트
  List<Todo> allTodo = [];

  @override
  Widget build(BuildContext context) {
    // 전체 메모 undone 완료(0)인 애들만 찾아 달라
    // where 반복문 같은 것
    List<Todo> undone = allTodo.where((element) {
      return element.done == 0;
    }).toList();

    // 전체 메모 done이 미완료(1)인 애들만 찾아 달라
    List<Todo> done = allTodo.where((element) {
      return element.done == 1;
    }).toList();

    // 전체 메모 undone 완료(0)인 애들만 찾아 달라
    // where 반복문 같은 것
    List<Todo> todayUndone = todos.where((element) {
      return element.done == 0;
    }).toList();

    // 전체 메모 done이 미완료(1)인 애들만 찾아 달라
    List<Todo> todayDone = todos.where((element) {
      return element.done == 1;
    }).toList();

    int searchIndex;

    return Column(
      children: [
        Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                child: Container(
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
                    children: [
                      SizedBox(height: 5,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          //Image.asset("assets/img/todo.png", width: 45, height: 45,),
                          Icon(Icons.access_time_rounded, color: Theme.of(context).appBarTheme.iconTheme.color),
                          SizedBox(width: 55,),
                          Text("${todos.length}", style: TextStyle(
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
                onTap: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => MyHomePage()));
                },
              ),
              SizedBox(width: 15,),
              InkWell(
                child: Container(
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
                    children: [
                      SizedBox(height: 5,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_chart_rounded, color: Theme.of(context).appBarTheme.iconTheme.color),
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
                onTap: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => Scaffold(
                            // appBar를 그냥 없애면 바디 전체가 appBar를 지운 부분인 상단부터 시작되기 때문에
                            // 보이기 않게 appBar를 감싸준다.
                            appBar: PreferredSize(
                              child: AppBar(),
                              preferredSize: Size.fromHeight(0),
                            ),
                            body: AllHistory(),
                          ),
                      )
                  );
                },
              ),
            ]
        ),
        Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                child: Container(
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
                    children: [
                      SizedBox(height: 5,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_box_outlined, color: Theme.of(context).appBarTheme.iconTheme.color),
                          SizedBox(width: 55,),
                          Text("${todayUndone.length}", style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold
                          ),),
                        ],
                      ),
                      SizedBox(height: 10,),
                      Text("TODO 미완료", style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold)
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => MyHomePage()));
                },
              ),
              SizedBox(width: 15,),
              InkWell(
                child: Container(
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
                    children: [
                      SizedBox(height: 5,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_box, color: Theme.of(context).appBarTheme.iconTheme.color),
                          SizedBox(width: 55,),
                          Text("${undone.length}", style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold
                          ),),
                        ],
                      ),
                      SizedBox(height: 10,),
                      Text("전체 미완료", style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold)
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => Scaffold(
                          // appBar를 그냥 없애면 바디 전체가 appBar를 지운 부분인 상단부터 시작되기 때문에
                          // 보이기 않게 appBar를 감싸준다.
                          appBar: PreferredSize(
                            child: AppBar(),
                            preferredSize: Size.fromHeight(0),
                          ),
                          body: UnDoneAllHistory(),
                        ),
                      )
                  );
                },
              ),
            ]
        ),
        Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                child: Container(
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
                    children: [
                      SizedBox(height: 5,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_box_outlined, color: Theme.of(context).appBarTheme.iconTheme.color),
                          SizedBox(width: 55,),
                          Text("${todayDone.length}", style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold
                          ),),
                        ],
                      ),
                      SizedBox(height: 10,),
                      Text("TODO 완료", style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold)
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => MyHomePage()));
                },
              ),
              SizedBox(width: 15,),
              InkWell(
                child: Container(
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
                    children: [
                      SizedBox(height: 5,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_box, color: Theme.of(context).appBarTheme.iconTheme.color),
                          SizedBox(width: 55,),
                          Text("${done.length}", style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold
                          ),),
                        ],
                      ),
                      SizedBox(height: 10,),
                      Text("전체 완료", style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold)
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => Scaffold(
                          // appBar를 그냥 없애면 바디 전체가 appBar를 지운 부분인 상단부터 시작되기 때문에
                          // 보이기 않게 appBar를 감싸준다.
                          appBar: PreferredSize(
                            child: AppBar(),
                            preferredSize: Size.fromHeight(0),
                          ),
                          body: DoneAllHistory(),
                        ),
                      )
                  );
                },
              ),
            ]
        ),
      ],
    );
  }
}