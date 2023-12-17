import 'package:barovik/radio_buttons.dart';
import 'package:barovik/text_field.dart';
import 'package:big_decimal/big_decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

enum Operation {
  plus,
  minus,
  multiply,
  divide,
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab1',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  RoundingMode roundingMode = RoundingMode.HALF_UP;

  Operation op1 = Operation.plus;
  Operation op2 = Operation.plus;
  Operation op3 = Operation.plus;

  Color color1 = Colors.white;
  Color color2 = Colors.white;
  Color color3 = Colors.white;
  Color color4 = Colors.white;

  TextEditingController? firstTextController;
  TextEditingController? secondTextController;
  TextEditingController? thirdTextController;
  TextEditingController? fourthTextController;

  String first = '0';
  String second = '0';
  String third = '0';
  String fourth = '0';
  BigDecimal result = BigDecimal.fromBigInt(BigInt.from(0));

  bool setValues() {
    if (firstTextController!.text.isEmpty) {
      firstTextController!.text = '0';
    }
    if (secondTextController!.text.isEmpty) {
      secondTextController!.text = '0';
    }
    if (thirdTextController!.text.isEmpty) {
      thirdTextController!.text = '0';
    }
    if (fourthTextController!.text.isEmpty) {
      fourthTextController!.text = '0';
    }

    first = firstTextController!.text.replaceAll(',', '.');
    second = secondTextController!.text.replaceAll(',', '.');
    third = thirdTextController!.text.replaceAll(',', '.');
    fourth = fourthTextController!.text.replaceAll(',', '.');

    String errorMessage = '';

    bool toReturn = true;
    if (!checkInput(first)) {
      errorMessage += 'Wrong input 1!\n';
      color1 = Colors.red;
      toReturn = false;
    } else {
      first = firstTextController!.text.replaceAll(' ', '');
      color1 = Colors.white;
    }
    if (!checkInput(second)) {
      errorMessage += 'Wrong input 2!\n';
      color2 = Colors.red;
      toReturn = false;
    } else {
      second = secondTextController!.text.replaceAll(' ', '');
      color2 = Colors.white;
    }
    if (!checkInput(third)) {
      errorMessage += 'Wrong input 3!\n';
      color3 = Colors.red;
      toReturn = false;
    } else {
      third = thirdTextController!.text.replaceAll(' ', '');
      color3 = Colors.white;
    }
    if (!checkInput(fourth)) {
      errorMessage += 'Wrong input 4!\n';
      color4 = Colors.red;
      toReturn = false;
    } else {
      fourth = fourthTextController!.text.replaceAll(' ', '');
      color4 = Colors.white;
    }

    setState(() {});
    if (!toReturn) {
      _showSnackBar(errorMessage);
    }

    return toReturn;
  }

  void _showSnackBar(String text) {
    var s = SnackBar(
      content: Text(text),
      duration: const Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context).showSnackBar(s);
  }

  bool checkInput(String input) {
    input = input.replaceAll(',', '.');
    var symbols = '1234567890.- ';
    bool lastWasSpace = false;
    bool afterDot = false;
    for (int i = 0; i < input.length; i++) {
      if (!symbols.contains(input[i])) {
        return false;
      }
      if (input[i] == ' ') {
        if (afterDot) {
          return false;
        }
        if (lastWasSpace) {
          return false;
        } else {
          lastWasSpace = true;
        }
      } else {
        lastWasSpace = false;
      }
      if (input[i] == '-' && i != 0) {
        return false;
      }
      if (input[i] == '.') {
        if (afterDot) {
          return false;
        }
        afterDot = true;
      }
    }
    var toCheckSpaces = input.substring(
        0, !input.contains('.') ? input.length : input.indexOf('.'));
    int nums = 0;
    for (int i = toCheckSpaces.length - 1; i >= 0; i--) {
      if (toCheckSpaces[i] == ' ') {
        if (nums != 3) {
          return false;
        } else {
          nums = 0;
        }
      } else {
        nums++;
      }
    }
    return true;
  }

  String formatResult(int digits, RoundingMode mode) {
    String res =
        result.withScale(digits, roundingMode: mode).toPlainString();
    var toAddSpaces =
        res.substring(0, !res.contains('.') ? res.length : res.indexOf('.'));
    var afterDot = res.contains('.')
        ? res.substring(res.indexOf('.') + 1, res.length)
        : '';
    int num = 0;
    bool hasMinus = false;
    if (res[0] == '-') {
      hasMinus = true;
      toAddSpaces = toAddSpaces.substring(1, toAddSpaces.length);
    }
    for (int i = toAddSpaces.length - 1; i >= 0; i--) {
      if (num < 2) {
        num++;
      } else {
        num = 0;
        toAddSpaces =
            '${toAddSpaces.substring(0, i)} ${toAddSpaces.substring(i, toAddSpaces.length)}';
      }
    }
    for (int i = afterDot.length - 1; i >= 0; i--) {
      if (afterDot[i] != '0') {
        break;
      } else {
        afterDot = afterDot.substring(0, afterDot.length - 1);
      }
    }
    res = (hasMinus ? '-' : '') +
        toAddSpaces +
        (afterDot.isEmpty ? '' : '.$afterDot');
    return res;
  }

  BigDecimal _calculate(
    BigDecimal firstVal,
    BigDecimal secondVal,
    Operation op,
  ) {
    BigDecimal result = BigDecimal.parse('0');
    switch (op) {
      case Operation.plus:
        result = firstVal + secondVal;
        break;
      case Operation.minus:
        result = firstVal - secondVal;
        break;
      case Operation.multiply:
        result = firstVal * secondVal;
        break;
      case Operation.divide:
        if (secondVal != BigDecimal.parse('0')) {
          result = firstVal.divide(
            secondVal,
            roundingMode: RoundingMode.HALF_EVEN,
            scale: 20,
          );
          break;
        } else {
          throw Exception("You can't divide by 0!");
        }
    }
    return result.withScale(
      10,
      roundingMode: RoundingMode.HALF_UP,
    );
  }

  void _straightCalculate() {
    var tempVal1 = _calculate(
      BigDecimal.parse(second),
      BigDecimal.parse(third),
      op2,
    );
    var tempVal2 = _calculate(
      BigDecimal.parse(first),
      tempVal1,
      op1,
    );
    setState(() {
      result = _calculate(tempVal2, BigDecimal.parse(fourth), op3);
    });
  }

  void _reversedCalculate() {
    var tempVal1 = _calculate(
      BigDecimal.parse(second),
      BigDecimal.parse(third),
      op2,
    );
    var tempVal2 = _calculate(
      tempVal1,
      BigDecimal.parse(fourth),
      op3,
    );
    setState(() {
      result = _calculate(tempVal2, BigDecimal.parse(first), op1);
    });
  }

  onResultButtonClicked() {
    if (setValues()) {
      try {
        if ((op3 == Operation.multiply || op3 == Operation.divide) &&
            (op1 != Operation.multiply && op1 != Operation.divide)) {
          _reversedCalculate();
        } else {
          _straightCalculate();
        }
      } on Exception catch (e) {
        _showSnackBar(e.toString());
      }
    }
  }

  @override
  void initState() {
    firstTextController = TextEditingController(text: first);
    secondTextController = TextEditingController(text: second);
    thirdTextController = TextEditingController(text: third);
    fourthTextController = TextEditingController(text: fourth);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Calculator'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(40),
                    ),
                    color: Colors.white,
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Text(
                      'Ivan Kapitanov 12 Group 3 course',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
                CustomTextField(
                  hintText: 'First number',
                  textController: firstTextController!,
                  fillColor: color1,
                ),
                RadioButtons(
                  onValueChanged: (Operation value) {
                    op1 = value;
                  },
                  op: op1,
                ),
                const Text(
                  '(',
                  style: TextStyle(
                    fontSize: 30,
                  ),
                ),
                CustomTextField(
                  hintText: 'Second number',
                  textController: secondTextController!,
                  fillColor: color2,
                ),
                RadioButtons(
                  onValueChanged: (Operation value) {
                    op2 = value;
                  },
                  op: op2,
                ),
                CustomTextField(
                  hintText: 'Third number',
                  textController: thirdTextController!,
                  fillColor: color3,
                ),
                const Text(
                  ')',
                  style: TextStyle(
                    fontSize: 30,
                  ),
                ),
                RadioButtons(
                  onValueChanged: (Operation value) {
                    op3 = value;
                  },
                  op: op3,
                ),
                CustomTextField(
                  hintText: 'Fourth number',
                  textController: fourthTextController!,
                  fillColor: color4,
                ),
                IconButton(
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.white,
                  ),
                  onPressed: () {
                    onResultButtonClicked();
                  },
                  icon: const Text(
                    '=',
                    style: TextStyle(
                      fontSize: 24,
                    ),
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(15.0),
                      ),
                      color: Colors.white),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      formatResult(6, RoundingMode.HALF_UP),
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: ListTile(
                        title: const Text(
                          'BANK',
                          style: TextStyle(fontSize: 10),
                        ),
                        horizontalTitleGap: 0,
                        leading: Radio<RoundingMode>(
                          value: RoundingMode.HALF_EVEN,
                          groupValue: roundingMode,
                          onChanged: (value) {
                            setState(() {
                              roundingMode = value!;
                            });
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListTile(
                        title: const Text(
                          'MATH',
                          style: TextStyle(fontSize: 10),
                        ),
                        horizontalTitleGap: 0,
                        leading: Radio<RoundingMode>(
                          value: RoundingMode.HALF_UP,
                          groupValue: roundingMode,
                          onChanged: (value) {
                            setState(() {
                              roundingMode = value!;
                            });
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListTile(
                        title: const Text(
                          'CUT',
                          style: TextStyle(fontSize: 10),
                        ),
                        horizontalTitleGap: 0,
                        leading: Radio<RoundingMode>(
                          value: RoundingMode.DOWN,
                          groupValue: roundingMode,
                          onChanged: (value) {
                            setState(() {
                              roundingMode = value!;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(15.0),
                      ),
                      color: Colors.white),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      formatResult(0, roundingMode),
                      style: const TextStyle(
                        fontSize: 16,
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
}
