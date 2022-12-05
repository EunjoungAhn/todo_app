import 'package:flutter/material.dart';
import 'data/todo/todo.dart';

class TodoWritePage extends StatefulWidget {

  final Todo todo;

  const TodoWritePage({Key key, this.todo}) : super(key: key);

  @override
  State<TodoWritePage> createState() => _TodoWritePageState();
}

class _TodoWritePageState extends State<TodoWritePage> {

  // TextFild를 사용하기 위해 필요한 변수
  TextEditingController nameController = TextEditingController();
  TextEditingController memoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            child: Text("저장", style: TextStyle(color: Colors.white),),
            onPressed: () {
              // 페이지 저장시 사용
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          if(index == 0){
            return Container(
              child: Text("제목"),
            );
          }
          else if(index == 1){
            return Container(
              child: TextField(
                controller: nameController,
              ),
            );
          }
          else if(index == 2){
            return Container(
              child: Row(
                children: [
                  Text("색상"),
                  Container(
                    width: 10,
                    height: 10,
                    color: Color(widget.todo.color), // widget. 하면 내 위의 StatefulWidget에 선언된 값을 가져올 수 있다.
                  )
                ],
              ),
            );
          }
          else if(index == 3){
            return Container(
              child: Row(
                children: [
                  Text("카테고리"),
                  Text(widget.todo.category)
                ],
              ),
            );
          }
          else if(index == 4){
            return Container(
                 child: Text("메모"),
            );
          }
          else if(index == 5){
            return Container(
              child: TextField(
                controller: memoController,
                maxLines: 10,
                minLines: 10,
                // 전체 윤각이 안보이느 보이게 설정
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black))
                ),
              ),
            );
          }

          return Container();
        },
        itemCount: 6,
      ),
    );
  }
}
