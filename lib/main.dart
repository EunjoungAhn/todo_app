import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/data/todo/database.dart';
import 'package:todo_app/data/todo/util.dart';
import 'package:todo_app/components/more_bottomsheet.dart';
import 'package:todo_app/service/notification_service.dart';
import 'package:todo_app/service/search.dart';
import 'package:todo_app/write.dart';
import 'components/app_themes.dart';
import 'data/todo/todo.dart';

final notification = AppNotificationService();

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  notification.initializeTimeZone();
  notification.initializeNotification();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false, // 디버그 배너삭제
      theme: AppThemes.lightTheme,
      darkTheme: AppThemes.darkTheme,
      home: //SearchScreen(),
      const MyHomePage(title: 'Flutter Demo Home Page'),
      // 기기의 폰트 사이즈에 의존하지 않게 설정
      builder: (context, child) => MediaQuery(
        child: child,
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      ),
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
 List<Todo> todos = [];
 final dbHelper = DatabaseHelper.instance;

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController searchController = TextEditingController();

  int selectIndex = 0; // 네비게이션 변경되는 인덱스 넘버

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
    setState(() { });
  }

  @override
  void initState() {
    getTodayTodo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // 시간 포맷 패키지로 포맷하기
    String nowTime = DateFormat('HH:mm').format(DateTime.now());
    return Scaffold(
      // appBar를 그냥 없애면 바디 전체가 appBar를 지운 부분인 상단부터 시작되기 때문에
      // 보이기 않게 appBar를 감싸준다.
      appBar: PreferredSize(
        child: AppBar(),
        preferredSize: Size.fromHeight(0),
      ),
      floatingActionButton: ![0].contains(selectIndex) ? Container() : FloatingActionButton(// 기록화면에서는 FAB 안보이게 설정
        child: Icon(Icons.add, color: Colors.white,),
        onPressed: () async {
          // 화면 이동하기
          Todo todo = await Navigator.of(context).push(
            // 화면을 이동하면서 생성자에서 List를 값을 받는데 수정도 하기 위해 받는 것이다.
              MaterialPageRoute(builder: (context) => TodoWritePage(
                todo: Todo(
                  title: "",
                  color: 0,
                  memo: "",
                  done: 0,
                  time: nowTime,
                  date: Utils.getFormatTime(DateTime.now())
                ))));

          // 새로 추가된 리스트 화면에 적용하기
          getTodayTodo();
        },
      ),
      body: getPage(),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.today_outlined),
            label: "TODO",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assessment_outlined),
            label: "기록",
          ),
        ],
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
        currentIndex: selectIndex,
        onTap: (index) {
          // 항상 모든 리스트를 가져와라
          if(index == 1){
            getAllTodo();
          }
          setState(() {
            selectIndex = index;
          });
        },
      ),
    );
  }

  Widget getPage(){
    if(selectIndex == 0){
      return getMain();
    }else{
      return getHistory();
    }
  }

  Widget getMain(){
   return ListView.builder(
      itemBuilder: (context, index) {
        if(index == 0){
          return Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              /*
              // 검색화면 주석 처리
                   SizedBox(height: 400,
                    child: SearchScreen(),
                   ),
              SizedBox(height: 15), // 검색 후, 보여지는 화면을 위해 사이즈를 주어야 에러가 안난다.
               */
              Text("Continue", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ],
            ),
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
                return InkWell(
                  child: TodoCardWidget(t: t),
                  onTap: () async {
                    setState(() {
                      if(t.done == 0){
                        t.done = 1;
                      }else{
                        t.done = 0;
                      }
                    });
                    await dbHelper.insertTodo(t);
                  },
                  onLongPress: () async {
                    // 화면 이동하기
                    Todo todo = await Navigator.of(context).push(
                      // 화면을 이동하면서 생성자에서 List를 값을 받는데 수정도 하기 위해 받는 것이다.
                        MaterialPageRoute(builder: (context) => TodoWritePage(
                            todo: t)));
                    getTodayTodo();
                  },
                );
              }),
            ),
          );
        }

        else if(index == 2){
          return Container(
            child: Text("Check", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
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
                return InkWell(
                  child: TodoCardWidget(t: t),
                  onTap: () async {
                    setState(() {
                      if(t.done == 0){
                        t.done = 1;
                      }else{
                        t.done = 0;
                      }
                    });
                    await dbHelper.insertTodo(t);
                  },
                  onLongPress: () async {
                    Todo todo = await Navigator.of(context).push(
                      // 화면을 이동하면서 생성자에서 List를 값을 받는데 수정도 하기 위해 받는 것이다.
                        MaterialPageRoute(builder: (context) =>
                            TodoWritePage(
                                todo: t)));
                    setState(() { });
                  },
                );
              }),
            ),
          );
        }

        return Container();
      },
      itemCount: 4,
    );
  }

  // 전체 기록을 가져오는 리스트
  List<Todo> allTodo = [];

  Widget getHistory(){
    return Column(
      children: const [
        SizedBox(height: 647,
          child: SearchScreen(),
        ),
        SizedBox(height: 15), // 검색 후, 보여지는 화면을 위해 사이즈를 주어야 에러가 안난다.
      ],
    );
    /*
      ListView.builder( // 기록 기록 화면 페이지
        itemBuilder: (context, index) {
          return InkWell(
            child: TodoCardWidget(t: allTodo[index]),
              onTap: () async {
                setState(() {
                  if(allTodo[index].done == 0){
                    allTodo[index].done = 1;
                  }else{
                    allTodo[index].done = 0;
                  }
                });
                await dbHelper.insertTodo(allTodo[index]);
              },
            onLongPress: () {
              showModalBottomSheet(context: context,
                builder: (context) => MoreActionBottomSheet(
                  onPressedUpdate: ()  async {
                    Todo todo = await Navigator.of(context).push(
                      // 화면을 이동하면서 생성자에서 List를 값을 받는데 수정도 하기 위해 받는 것이다.
                        MaterialPageRoute(builder: (context) =>
                            TodoWritePage(
                                todo: allTodo[index])));
                    setState(() { });
                  },
                  onPressedDelete: () {
                    dbHelper.deleteTodo(allTodo[index].id);
                    Navigator.pop(context);
                    setState(() {
                      getTodayTodo();
                      getAllTodo();
                    });
                  },
                ),
              );
            }, // onTap
          );
        },
        itemCount: allTodo.length,
      );
     */
  } // getHistory

}

class TodoCardWidget extends StatelessWidget {
  final Todo t;
  const TodoCardWidget({Key key, this.t}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int now = Utils.getFormatTime(DateTime.now());
    DateTime time = Utils.numToDateTime(t.date); // 실제 날자를 변경

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
            children: [
              now == t.date ? Text("${time.month}월 ${time.day}일",
                  style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold))
              : Text("${time.month}월 ${time.day}일",
                  style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold)
              ),
              SizedBox(width: 20,),
              Text(t.time,
                style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(height: 5,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(t.title, style: TextStyle(fontSize: 18, color: Colors.black87, fontWeight: FontWeight.bold),),
              Text(t.done == 0 ? "미완료" : "완료", style: Theme.of(context).textTheme.subtitle1,),
            ],
          ),
          Container(height: 8,),
          Text(t.memo, style: TextStyle(color: Colors.black45, fontWeight: FontWeight.bold),),
        ],
      ),
    );
  }
}

