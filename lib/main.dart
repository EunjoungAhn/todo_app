import 'package:flutter/material.dart';
import 'package:todo_app/data/todo/util.dart';
import 'package:todo_app/write.dart';

import 'data/todo/todo.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}
// todo가 가지고 있는 여러 값을 가져오기 위해 변수 설정
 List<Todo> todos = [
   Todo(
     title: "강의1 듣기1",
     memo: "앱 개발 강의2",
     color: Colors.redAccent.value, // 컬러 코드를 인트값으로 변경
     done: 0,
     category: "공부",
     date: 20221205
   ),
   Todo(
       title: "강의2 듣기2",
       memo: "앱 개발 강의2",
       color: Colors.blue.value, // 컬러 코드를 인트값으로 변경
       done: 1,
       category: "공부",
       date: 20221205
   )
 ];

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar를 그냥 없애면 바디 전체가 appBar를 지운 부분인 상단부터 시작되기 때문에
      // 보이기 않게 appBar를 감싸준다.
      appBar: PreferredSize(
        child: AppBar(),
        preferredSize: Size.fromHeight(0),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add, color: Colors.white,),
        onPressed: () {
          // 화면 이동하기
          Navigator.of(context).push(
            // 화면을 이동하면서 생성자에서 List를 값을 받는데 수정도 하기 위해 받는 것이다.
              MaterialPageRoute(builder: (context) => TodoWritePage(
                todo: Todo(
                  title: "",
                  color: 0,
                  memo: "",
                  done: 0,
                  category: "",
                  date: Utils.getFormatTime(DateTime.now())
                ))));
        },
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          if(index == 0){
            return Container(
              child: Text("오늘하루", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
              margin: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            );
          }else if(index == 1){

            // where 반복문 같은 것
            List<Todo> undone = todos.where((element) {
              // 리스트 값의 done이 완료(0)인 애들만 찾아 달라
              return element.done == 0;
            }).toList();

            return Container(
              child: Column(
                // List.generate 어떤 리스트를 어떻게 만들기 (리스트의 길이 설정, 리스트의 인덱스)
                children: List.generate(undone.length, (index) {
                  // 각각 리스트의 데이터 접근하기
                  Todo t = undone[index];
                  return Container(
                    decoration: BoxDecoration(
                      color: Color(t.color),
                      borderRadius: BorderRadius.circular(16)
                    ),
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                    margin: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(t.title, style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),),
                            Text(t.done == 0 ? "미완료" : "완료", style: TextStyle(color: Colors.white),),
                          ],
                        ),
                        Container(height: 8,),
                        Text(t.memo, style: TextStyle(color: Colors.white),),
                      ],
                    ),
                  );
                }),
              ),
            );
          }

          else if(index == 2){
            return Container(
              child: Text("완료된 하루", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
              margin: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            );
          }else if(index == 3){

            List<Todo> done = todos.where((element) {
              return element.done == 1;
            }).toList();

            return Container(
              child: Column(
                // List.generate 어떤 리스트를 어떻게 만들기 (리스트의 길이 설정, 리스트의 인덱스)
                children: List.generate(done.length, (index) {
                  // 각각 리스트의 데이터 접근하기
                  Todo t = done[index];
                  return Container(
                    decoration: BoxDecoration(
                        color: Color(t.color),
                        borderRadius: BorderRadius.circular(16)
                    ),
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                    margin: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(t.title, style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),),
                            Text(t.done == 0 ? "미완료" : "완료", style: TextStyle(color: Colors.white),),
                          ],
                        ),
                        Container(height: 8,),
                        Text(t.memo, style: TextStyle(color: Colors.white),),
                      ],
                    ),
                  );
                }),
              ),
            );
          }

          return Container();
        },
        itemCount: 4,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.today_outlined),
            label: "오늘"
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assessment_outlined),
            label: "기록"
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.more_horiz),
              label: "더보기"
          ),
        ],
      ),
    );
  }
}