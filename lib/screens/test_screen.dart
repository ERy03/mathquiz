import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class TestScreen extends StatefulWidget {
  final int numberOfQuestions;

  TestScreen({required this.numberOfQuestions});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  // score part
  int remainingQuestions = 0;
  int numberCorrect = 0;
  int correctRate = 0;

  // question part
  int numberLeft = 0;
  int numberRight = 0;
  String operator = '';
  String answerString = '';

  // booleans
  bool isCalcButtonEnabled = false;
  bool isAnswerCheckButtonEnabled = false;
  bool isBackButtonEnabled = false;
  bool isCorrectIncorrectImageEnabled = false;
  bool isEndMessageEnabled = false;
  bool isCorrect = false;

  late AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();
    numberCorrect = 0;
    correctRate = 0;
    remainingQuestions = widget.numberOfQuestions;

    _audioPlayer = AudioPlayer();
    setQuestion();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Column(
              children: [
                // score part
                _scorePart(),
                // question part
                _questionPart(),
                // calculator part
                _calculatorPart(),
                // answer button part
                _answerButtonPart(),
                // back button part
                _backButtonPart(),
              ],
            ),
            _correctIncorrectImage(),
            _endMessage(),
          ],
        ),
      ),
    );
  }

// TODO
  Widget _scorePart() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
      child: Table(
        children: [
          TableRow(
            children: [
              Center(child: Text('残り問題数', style: TextStyle(fontSize: 10.0))),
              Center(child: Text('正解数', style: TextStyle(fontSize: 10.0))),
              Center(child: Text('正答率', style: TextStyle(fontSize: 10.0))),
            ],
          ),
          TableRow(
            children: [
              Center(
                  child: Text(remainingQuestions.toString(),
                      style: TextStyle(fontSize: 18.0))),
              Center(
                  child: Text(numberCorrect.toString(),
                      style: TextStyle(fontSize: 18.0))),
              Center(
                  child: Text(correctRate.toString(),
                      style: TextStyle(fontSize: 18.0))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _questionPart() {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 80.0),
      child: Row(
        children: [
          // number left
          Expanded(
            flex: 2,
            child: Center(
              child: Text(
                numberLeft.toString(),
                style: TextStyle(fontSize: 36.0),
              ),
            ),
          ),
          // operator
          Expanded(
            flex: 1,
            child: Center(
              child: Text(
                operator,
                style: TextStyle(fontSize: 30.0),
              ),
            ),
          ),
          // number right
          Expanded(
            flex: 2,
            child: Center(
              child: Text(
                numberRight.toString(),
                style: TextStyle(fontSize: 36.0),
              ),
            ),
          ),
          // Equal sign
          Expanded(
            flex: 1,
            child: Center(
              child: const Text(
                "=",
                style: TextStyle(fontSize: 30.0),
              ),
            ),
          ),
          // answer string
          Expanded(
            flex: 3,
            child: Center(
              child: Text(
                answerString,
                style: TextStyle(fontSize: 60.0),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _calculatorPart() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 50.0),
        child: Table(
          children: [
            TableRow(
              children: [
                _calcButton('7'),
                _calcButton('8'),
                _calcButton('9'),
              ],
            ),
            TableRow(
              children: [
                _calcButton('4'),
                _calcButton('5'),
                _calcButton('6'),
              ],
            ),
            TableRow(
              children: [
                _calcButton('1'),
                _calcButton('2'),
                _calcButton('3'),
              ],
            ),
            TableRow(
              children: [
                _calcButton('0'),
                _calcButton('-'),
                _calcButton('C'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _calcButton(String numString) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Colors.brown,
          onPrimary: Colors.white,
        ),
        onPressed: isCalcButtonEnabled ? () => inputAnswer(numString) : null,
        child: Text(
          numString,
          style: TextStyle(fontSize: 24.0),
        ),
      ),
    );
  }

  Widget _answerButtonPart() {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Colors.brown,
            onPrimary: Colors.white,
          ),
          onPressed: isCalcButtonEnabled ? () => answerCheck() : null,
          child: Text(
            "答え合わせ",
            style: TextStyle(fontSize: 14.0),
          ),
        ),
      ),
    );
  }

  Widget _backButtonPart() {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Colors.brown,
            onPrimary: Colors.white,
          ),
          onPressed: isBackButtonEnabled ? () => closeTestScreen() : null,
          child: Text(
            "戻る",
            style: TextStyle(fontSize: 14.0),
          ),
        ),
      ),
    );
  }

  Widget _correctIncorrectImage() {
    if (isCorrectIncorrectImageEnabled) {
      if (isCorrect) {
        return Center(
          child: Image.asset("assets/images/pic_correct.png"),
        );
      }
      return Center(
        child: Image.asset("assets/images/pic_incorrect.png"),
      );
    } else {
      return Container();
    }
  }

  Widget _endMessage() {
    if (isEndMessageEnabled) {
      return Center(
        child: Text(
          "Finish",
          style: TextStyle(fontSize: 100.0),
        ),
      );
    } else {
      return Container();
    }
  }

  void setQuestion() {
    isCalcButtonEnabled = true;
    isAnswerCheckButtonEnabled = true;
    isBackButtonEnabled = false;
    isCorrectIncorrectImageEnabled = false;
    isEndMessageEnabled = false;
    answerString = "";

    Random random = Random();
    numberLeft = random.nextInt(100) + 1;
    numberRight = random.nextInt(100) + 1;
    operator = random.nextInt(2) == 0 ? "+" : "-";

    setState(() {});
  }

  inputAnswer(String numString) {
    setState(() {
      if (numString == "C") {
        answerString = "";
        return;
      }
      if (numString == "-") {
        if (answerString == "") answerString = "-";
        return;
      }
      if (numString == "0") {
        if (answerString != "0" && answerString != "-")
          answerString += numString;
        return;
      }
      if (answerString == "0") {
        answerString = numString;
        return;
      }
      answerString += numString;
    });
  }

  answerCheck() {
    if (answerString == "" || answerString == "-") {
      return;
    }

    isCalcButtonEnabled = false;
    isAnswerCheckButtonEnabled = false;
    isBackButtonEnabled = false;
    isCorrectIncorrectImageEnabled = true;
    isEndMessageEnabled = false;

    remainingQuestions--;

    var myAnswer = int.parse(answerString).toInt();
    var realAnswer = 0;

    if (operator == "+") {
      realAnswer = numberLeft + numberRight;
    } else {
      realAnswer = numberLeft - numberRight;
    }

    if (myAnswer == realAnswer) {
      isCorrect = true;
      numberCorrect++;
    } else {
      isCorrect = false;
    }

    _playSound(isCorrect);

    correctRate =
        ((numberCorrect / (widget.numberOfQuestions - remainingQuestions)) *
                100)
            .toInt();

    if (remainingQuestions == 0) {
      isCalcButtonEnabled = false;
      isAnswerCheckButtonEnabled = false;
      isBackButtonEnabled = true;
      isCorrectIncorrectImageEnabled = true;
      isEndMessageEnabled = true;
    } else {
      Timer(Duration(seconds: 1), () => setQuestion());
    }

    setState(() {});
  }

  void _playSound(bool isCorrect) async {
    if (isCorrect) {
      await _audioPlayer.setAsset("assets/sounds/sound_correct.mp3");
    } else {
      await _audioPlayer.setAsset("assets/sounds/sound_incorrect.mp3");
    }
    _audioPlayer.play();
  }

  closeTestScreen() {
    Navigator.pop(context);
  }
}
