import 'package:flutter/material.dart';
import 'package:todo_app/app_widgets.dart';

class MoreActionBottomSheet extends StatelessWidget {
  const MoreActionBottomSheet({Key key, this.onPressedDelete}) : super(key: key);

  // onPressed를 받아서 처리하려고 class 변수로 설정
  final VoidCallback onPressedDelete;

  @override
  Widget build(BuildContext context) {
    return BottomSheetBody(children: [
      TextButton(
        style: TextButton.styleFrom(foregroundColor: Colors.red),
        onPressed: onPressedDelete,
        child: const Text('기록 삭제'),
      ),
    ],
    );
  }
}