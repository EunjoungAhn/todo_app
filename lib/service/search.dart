import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
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
                    autofocus: true,
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
        ],
      ),
    );
  }
}
