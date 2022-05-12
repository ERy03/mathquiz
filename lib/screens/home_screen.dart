import 'package:flutter/material.dart';
import 'package:mathquiz/screens/test_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<DropdownMenuItem<int>> _menuItems = [];
  int _numberOfQuestions = 0;

  @override
  void initState() {
    super.initState();
    setMenuItems();
    _numberOfQuestions = _menuItems[0].value!;
  }

  void setMenuItems() {
    _menuItems.add(DropdownMenuItem(
      value: 10,
      child: Text(10.toString()),
    ));
    _menuItems.add(DropdownMenuItem(
      value: 20,
      child: Text(20.toString()),
    ));
    _menuItems.add(DropdownMenuItem(
      value: 30,
      child: Text(30.toString()),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Column(
              children: [
                Image.asset('assets/images/image_title.png'),
                SizedBox(height: 50.0),
                Text(
                  "問題数を選択して「スタート」ボタンを押してください",
                  style: TextStyle(
                    fontSize: 12.0,
                  ),
                ),
                SizedBox(height: 75.0),
                DropdownButton(
                  items: _menuItems,
                  value: _numberOfQuestions,
                  onChanged: (int? selectedValue) {
                    setState(() {
                      _numberOfQuestions = selectedValue!;
                    });
                  },
                ),
                Expanded(
                  child: Container(
                    alignment: AlignmentDirectional.bottomCenter,
                    child: ElevatedButton.icon(
                      icon: Icon(Icons.skip_next),
                      label: Text("スタート"),
                      onPressed: () => startTestScreen(context),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.brown,
                        onPrimary: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  startTestScreen(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => TestScreen(numberOfQuestions: _numberOfQuestions,)));
  }
}
