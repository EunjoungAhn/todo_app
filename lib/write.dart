import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:todo_app/components/app_constants.dart';
import 'package:todo_app/components/app_widgets.dart';
import 'package:todo_app/data/todo/database.dart';
import 'package:todo_app/main.dart';
import 'data/todo/todo.dart';

class TodoWritePage extends StatefulWidget {

  final Todo todo;

  const TodoWritePage({Key key, this.todo}) : super(key: key);

  @override
  State<TodoWritePage> createState() => TodoWritePageState();
}

class TodoWritePageState extends State<TodoWritePage> {

  // TextFild를 사용하기 위해 필요한 변수
  TextEditingController nameController = TextEditingController();
  TextEditingController memoController = TextEditingController();

  final dbHelper = DatabaseHelper.instance;

  int colorIndex = 0;
  int alarmId = 0;

  // 시간 포맷 패키지로 포맷하기
  String nowTime = DateFormat('HH:mm').format(DateTime.now());
  @override
  void initState() {
    super.initState();
    nameController.text = widget.todo.title;
    memoController.text = widget.todo.memo;
    nowTime = widget.todo.time;
  }

  @override
  Widget build(BuildContext context) {
    final initTime = DateFormat('HH:mm').parse(nowTime);
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            child: Text("저장", style: Theme.of(context).textTheme.subtitle1,),
            onPressed: () async {
              // 페이지 저장시 사용
              widget.todo.title = nameController.text;
              widget.todo.memo = memoController.text;
              await dbHelper.insertTodo(widget.todo);

              //알림 등록
              final result = await notification.addNotifcication(
                alarmTimeStr: nowTime,
                title: "${nameController.text}",
                body: "자세한 내용은 앱에서 확인해주세요!",
                id: alarmId + 1,
                );

                if(!result){
                  // 알림 설정 확인
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text("알림 권한이 없습니다."),
                              TextButton(onPressed: openAppSettings,
                                child: Text("설정창으로 이동"),
                              )
                            ],
                          )
                      )
                  );
                }

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
              child: Text("제목", style: Theme.of(context).textTheme.subtitle1,),
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
                    Text("색상", style: Theme.of(context).textTheme.subtitle1,),
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
                    Text("알림시간", style: Theme.of(context).textTheme.subtitle1),
                    Text(nowTime, style: Theme.of(context).textTheme.subtitle1),
                  ],
                ),
              ),
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return BottomSheetBody(
                      children: [
                        SizedBox(// CupertinoDatePicker 타입을 표시하기 위해 높이를 지정해야 한다.
                          height: 200,
                          child:
                          CupertinoDatePicker(onDateTimeChanged: (dateTime) {
                            nowTime = DateFormat('HH:mm').format(dateTime);
                            print(nowTime);
                          },
                            mode: CupertinoDatePickerMode.time,
                            initialDateTime: initTime,
                          ),
                        ),
                        SizedBox(width: regularSpace),
                        Row(
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: submitButtonHeight,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    textStyle: Theme.of(context).textTheme.subtitle1,
                                    backgroundColor: Colors.white,
                                    foregroundColor: Colors.black,
                                  ),
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text("취소"),
                                ),
                              ),
                            ),
                            SizedBox(width: smallSpace),
                            Expanded(
                              child: SizedBox(
                                height: submitButtonHeight,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(textStyle: Theme.of(context).textTheme.subtitle1),
                                  // pop을 할때 nowTime 데이터를 넘긴다.
                                  onPressed: (){
                                    setState(() {
                                      Navigator.pop(context, nowTime);
                                      widget.todo.time = nowTime;
                                    });
                                  },
                                  child: const Text("선택"),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ).then((value) {
                  if(value == null || value is! DateTime) return;
                  nowTime;
                });
              },
            );
          }
          else if(index == 4){
            return Container(
              margin: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                 child: Text("메모", style: Theme.of(context).textTheme.subtitle1,),
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
