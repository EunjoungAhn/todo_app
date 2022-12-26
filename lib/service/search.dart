import 'dart:async';

import 'package:flutter/material.dart';
import 'package:todo_app/components/more_bottomsheet.dart';
import 'package:todo_app/data/todo/todo.dart';
import 'package:todo_app/data/todo/database.dart';
import 'package:todo_app/main.dart';
import 'package:todo_app/write.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  StreamController<_SearchScreenState> streamController = StreamController<_SearchScreenState>();
  final TextEditingController _filter = TextEditingController();
  FocusNode focusNode = FocusNode(); // 현재 검색 위젯에 커서가 있는지 상태 확인
  String _searchText = "";

  /* 상태관리 - 검색 위젯을 컨트롤하는 _filter가 변화를 감지하여
  _searchText의 상태를 변화시키는 코드
   */
  _SearchScreenState(){
    _filter.addListener(() {
      setState(() {
        _searchText = _filter.text;
      });
    });
  }

  final dbHelper = DatabaseHelper.instance;

  // 모든 메모들을 가져와라
  void getAllTodo() async {
    allTodo = await dbHelper.getAllTodo();
    setState(() { });
  }

  /*
  void showPopup(context, title, memo){
    showDialog(
        context: context,
        builder: (context) {
          // 팝업창 구성하기
          return Dialog(
            child: Container(
              width: 200,
              // MediaQuery.of(context).size.width * 0.7, //디바이스 너비의 70%를 컨테이너가 사용
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              child: Column(
                children: [
                  SizedBox(height: 10,),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.black45,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Text(
                      memo,
                      maxLines: 12,
                      style: TextStyle(
                        fontSize: 8,
                        color: Colors.black45,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
    );
  }
   */

  // 전체 기록을 가져오는 리스트
  List<Todo> allTodo = [];

   Widget _buildBody(BuildContext context){
    return FutureBuilder(
      future: DatabaseHelper.instance.getAllTodo(),
      builder: (BuildContext context,
          AsyncSnapshot<List<Todo>> snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();
        return _buildList(context, snapshot.data);
      },
    );
  }

  Widget _buildList(BuildContext context, List<Todo> todoList){
    List<Todo> searchResults = [];
    // 데이터에 검색 키워드가 있는지 필터링으로 리스트를 생성
    for(Todo t in todoList){
      if(t.title.toString().contains(_searchText)){
        searchResults.add(t);
      }
    }
    return Expanded(
          child:
          ListView.builder(
          itemBuilder: (context, index) {
            return InkWell(
              child: TodoCardWidget(t: searchResults[index]),
              onTap: () async {

                /*
                showPopup(context, searchResults[index].title, searchResults[index].memo);
                 */

                /*
                // 수정 화면으로 이동
                Todo todo = await Navigator.of(context).push(
                  // 화면을 이동하면서 생성자에서 List를 값을 받는데 수정도 하기 위해 받는 것이다.
                    MaterialPageRoute(builder: (context) => TodoWritePage(
                        todo: searchResults[1])));
                getAllTodo();
                 */

                // 클릭시 완료, 미완료 처리 =
                setState(() {
                  if(searchResults[index].done == 0){
                    searchResults[index].done = 1;
                  }else{
                    searchResults[index].done = 0;
                  }
                });
                await dbHelper.insertTodo(searchResults[index]);

              },
              onLongPress: () {
                showModalBottomSheet(context: context,
                  builder: (context) => MoreActionBottomSheet(
                    onPressedUpdate: ()  async {
                      Todo todo = await Navigator.of(context).push(
                        // 화면을 이동하면서 생성자에서 List를 값을 받는데 수정도 하기 위해 받는 것이다.
                          MaterialPageRoute(builder: (context) =>
                              TodoWritePage(
                                  todo: searchResults[index])));
                      setState(() { });
                      print(searchResults[index]);
                    },
                    onPressedDelete: () {
                      dbHelper.deleteTodo(searchResults[index].id);
                      Navigator.pop(context);
                      setState(() {
                        getAllTodo();
                      });
                    },
                  ),
                );
              }, // onTap
            );
          },
          itemCount: searchResults.length,
        ),
      );
    }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        children: [
          //Padding(padding: EdgeInsets.all(30)),
          Container(
            color: Color(0xffa6b9c0),
            padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
            child: Row(
              children: [
                Expanded(
                  flex:6,
                  child: TextField(
                    focusNode: focusNode,
                    style: TextStyle(fontSize: 15),
                    autofocus: false,
                    controller: _filter,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Color(0xffa6b9c0),
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.white60,
                        size: 20,
                      ),
                      //뒤에 붙는 아이콘 - 클릭 했을때 캔슬 아이콘
                      suffixIcon: focusNode.hasFocus
                          ? IconButton(
                        icon: Icon(
                          Icons.cancel,
                          size: 20,
                        ),
                        onPressed: () {
                          setState(() {
                            _filter.clear();
                            _searchText = "";
                          });
                        },
                      )
                          : Container(),
                      hintText: '검색',
                      border: InputBorder.none,
                      labelStyle: TextStyle(color: Colors.white),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                    ),
                  ),
                ),
                // 취소 버튼 처리
                focusNode.hasFocus
                    ? Expanded(child:
                        TextButton(
                          child: Text("취소"),
                          onPressed: () {
                            setState(() {
                              _filter.clear();
                              _searchText = "";
                              focusNode.unfocus();
                            });
                          },
                        ),
                      )
                    : Expanded(flex: 0, child: Container(),
                )
              ],
            ),
          ),
          _buildBody(context),
        ],
      ),
    );
  }
}
