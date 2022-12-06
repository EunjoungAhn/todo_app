import 'package:flutter/material.dart';
import 'package:todo_app/data/todo/database.dart';
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

  final dbHelper = DatabaseHelper.instance;

  int colorIndex = 0;
  int categoryIndex = 0;

  @override
  void initState() {
    super.initState();
    nameController.text = widget.todo.title;
    memoController.text = widget.todo.memo;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            child: Text("저장", style: TextStyle(color: Colors.white),),
            onPressed: () async {
              // 페이지 저장시 사용
              widget.todo.title = nameController.text;
              widget.todo.memo = memoController.text;
              await dbHelper.insertTodo(widget.todo);
              
              // 작성된 정보를 메인 페이지로 넘기면서 현재 화면 제거
              Navigator.of(context).pop(widget.todo);
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          if(index == 0){
            return Container(
              margin: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              child: Text("제목", style: TextStyle(fontSize: 20),),
            );
          }
          else if(index == 1){
            return Container(
              child: TextField(
                controller: nameController,
              ),
              margin: EdgeInsets.symmetric(horizontal: 16),
            );
          }
          else if(index == 2){
            return InkWell(
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("색상", style: TextStyle(fontSize: 20),),
                    Container(
                      width: 20,
                      height: 20,
                      color: Color(widget.todo.color), // widget. 하면 내 위의 StatefulWidget에 선언된 값을 가져올 수 있다.
                    )
                  ],
                ),
              ),
                onTap: () {
                  List<Color> colors = [
                    Color(0xFF80d3f4),
                    Color(0xFFa794fa),
                    Color(0xFFfb91d1),
                    Color(0xFFfb8a94),
                    Color(0xFFfebd9a),
                    Color(0xFF51e29d),
                    Color(0xFFFFFFFF),
                  ];

                  widget.todo.color = colors[colorIndex].value;
                  colorIndex++;
                  setState(() {
                    // 해당 리스트의 길이로 나누면 인덱스를 순회한다.
                    colorIndex = colorIndex % colors.length;
                  });
              },
            );
          }
          else if(index == 3){
            return InkWell(
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("카테고리", style: TextStyle(fontSize: 20),),
                    Text(widget.todo.category)
                  ],
                ),
              ),
              onTap: () {
                List<String> category = ["공부", "게임", "운동"];

                widget.todo.category = category[categoryIndex];
                categoryIndex++;
                setState(() {
                  categoryIndex = categoryIndex % category.length;
                });

              },
            );
          }
          else if(index == 4){
            return Container(
              margin: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                 child: Text("메모", style: TextStyle(fontSize: 20),),
            );
          }
          else if(index == 5){
            return Container(
              margin: EdgeInsets.symmetric(vertical: 1, horizontal: 16),
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
