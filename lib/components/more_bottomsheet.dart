import 'package:flutter/material.dart';
import 'package:todo_app/components/app_widgets.dart';

class MoreActionBottomSheet extends StatelessWidget {
  const MoreActionBottomSheet({Key key, this.onPressedDelete, this.onPressedUpdate}) : super(key: key);

  // onPressed를 받아서 처리하려고 class 변수로 설정
  final VoidCallback onPressedDelete;
  final VoidCallback onPressedUpdate;

  @override
  Widget build(BuildContext context) {
    return BottomSheetBody(children: [
      TextButton(
        style: TextButton.styleFrom(foregroundColor: Colors.blueAccent),
        onPressed: onPressedUpdate,
        child: const Text('메모 수정'),
      ),
      TextButton(
        style: TextButton.styleFrom(foregroundColor: Colors.red),
        onPressed: onPressedDelete,
        child: const Text('메모 삭제'),
      ),
    ],
    );
  }
}