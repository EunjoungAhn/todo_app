import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:todo_app/components/app_constants.dart';
import 'package:todo_app/components/app_widgets.dart';
import 'package:todo_app/data/todo/database.dart';
import 'package:todo_app/service/notification_service.dart';
import 'data/todo/todo.dart';

final notification = AppNotificationService();

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

  double _seleteColor = 0;
  List<Color> colors = [
    Color(0xFF80d3f4),
    Color(0xFFa794fa),
    Color(0xFFfb91d1),
    Color(0xFF51e29d),
  ];

  // 시간 포맷 패키지로 포맷하기
  String nowTime = DateFormat('HH:mm').format(DateTime.now());

  @override
  void initState() {
    super.initState();
    nameController.text = widget.todo.title;
    memoController.text = widget.todo.memo;
    nowTime = widget.todo.time;
  }

  int alarmNum = Random().nextInt(1000)+1;

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
              widget.todo.alarmKey = alarmNum.toString() + nowTime.replaceAll(':', '');
              await dbHelper.insertTodo(widget.todo);

              //알림 등록
              final result = await notification.addNotifcication(
                id: alarmNum,
                alarmTimeStr: nowTime,
                title: "${nameController.text}",
                body: "자세한 내용은 앱에서 확인해주세요!",
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
                print("알람 등록: ${widget.todo.alarmKey}");
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
            return Container(
              margin: EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InkWell(
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: colors[0].value == widget.todo.color ? Color(0xFF80d3f4) : Color(0xFFFFFFFF),
                          boxShadow: [
                            BoxShadow(
                              color: colors[0].value == widget.todo.color ? Colors.grey.withOpacity(_seleteColor) : Color(0xFF80d3f4),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: Offset(0, 3), // changes position of shadow
                            )
                          ]
                      ),
                      // Color(0xFF80d3f4),
                    ),
                    onTap: () {
                      setState(() {
                        widget.todo.color = colors[0].value;
                      });
                    },
                  ),
                  InkWell(
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: colors[1].value == widget.todo.color ? Color(0xFFa794fa) : Color(0xFFFFFFFF),
                          boxShadow: [
                            BoxShadow(
                              color: colors[1].value == widget.todo.color ? Colors.grey.withOpacity(_seleteColor) : Color(0xFFa794fa),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: Offset(0, 3), // changes position of shadow
                            )
                          ]
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        widget.todo.color = colors[1].value;
                        BoxShadow(
                          color: colors[1].value == widget.todo.color ? Colors.grey.withOpacity(_seleteColor) : Color(0xFFa794fa),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3), // changes position of shadow
                        );
                      });
                    },
                  ),
                  InkWell(
                    hoverColor: Colors.red,
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: colors[2].value == widget.todo.color ? Color(0xFFfb91d1) : Color(0xFFFFFFFF),
                          boxShadow: [
                            BoxShadow(
                              color: colors[2].value == widget.todo.color ? Colors.grey.withOpacity(_seleteColor) : Color(0xFFfb91d1),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: Offset(0, 3), // changes position of shadow
                            )
                          ]
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        widget.todo.color = colors[2].value;
                      });
                    },
                  ),
                  InkWell(
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: colors[3].value == widget.todo.color ? Color(0xFF51e29d) : Color(0xFFFFFFFF),
                          boxShadow: [
                            BoxShadow(
                              color: colors[3].value == widget.todo.color ? Colors.grey.withOpacity(_seleteColor) : Color(0xFF51e29d),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: Offset(0, 3), // changes position of shadow
                            )
                          ]
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        widget.todo.color = colors[3].value;
                      });
                    },
                  ),
                ],
              ),
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
