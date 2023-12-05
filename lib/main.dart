import 'package:big_decimal/big_decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

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
  void onButtonPlus() {
    setValues();
    result = BigDecimal.parse(first) + BigDecimal.parse(second);
    setState(() {});
  }

  void setValues() {
    if (firstTextController!.text.isEmpty) {
      firstTextController!.text = '0';
    }
    if (secondTextController!.text.isEmpty) {
      secondTextController!.text = '0';
    }

    first = firstTextController!.text.replaceAll(' ', '');
    second = secondTextController!.text.replaceAll(' ', '');
  }

  void onButtonMinus() {
    setValues();
    result = BigDecimal.parse(first) - BigDecimal.parse(second);
    setState(() {});
  }

  void onButtonDivide() {
    setValues();
    result = BigDecimal.parse(first).divide(
      BigDecimal.parse(second),
      roundingMode: RoundingMode.HALF_EVEN,
      scale: 20,
    );
    setState(() {});
  }

  void onButtonMultiply() {
    setValues();
    result = BigDecimal.parse(first) * BigDecimal.parse(second);
    setState(() {});
  }

  String first = '0';
  String second = '0';
  BigDecimal result = BigDecimal.fromBigInt(BigInt.from(0));

  TextEditingController? firstTextController;

  TextEditingController? secondTextController;

  @override
  void initState() {
    firstTextController = TextEditingController(text: first);
    secondTextController = TextEditingController(text: second);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Calculator'),
      ),
      body: Center(
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
              TextField(
                inputFormatters: [
                  ThousandsSeparatorInputFormatter(),
                ],
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: BorderSide.none,
                  ),
                  hintText: 'First number',
                  filled: true,
                  fillColor: Colors.white,
                ),
                controller: firstTextController,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                    onPressed: () => onButtonPlus(),
                    style: TextButton.styleFrom(backgroundColor: Colors.white),
                    child: const Text(
                      '+',
                      style: TextStyle(
                        fontSize: 25,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () => onButtonMinus(),
                    style: TextButton.styleFrom(backgroundColor: Colors.white),
                    child: const Text(
                      '-',
                      style: TextStyle(fontSize: 25),
                    ),
                  ),
                  TextButton(
                    onPressed: () => second == "0" ? null : onButtonDivide(),
                    style: TextButton.styleFrom(backgroundColor: Colors.white),
                    child: const Text(
                      '/',
                      style: TextStyle(fontSize: 25),
                    ),
                  ),
                  TextButton(
                    onPressed: () => onButtonMultiply(),
                    style: TextButton.styleFrom(backgroundColor: Colors.white),
                    child: const Text(
                      'x',
                      style: TextStyle(fontSize: 25),
                    ),
                  ),
                ],
              ),
              TextField(
                inputFormatters: [
                  ThousandsSeparatorInputFormatter(),
                ],
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: BorderSide.none,
                  ),
                  hintText: 'Second number',
                  filled: true,
                  fillColor: Colors.white,
                ),
                controller: secondTextController,
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
                    result.toString(),
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
    );
  }
}

class ThousandsSeparatorInputFormatter extends TextInputFormatter {
  static const separator = ' '; // Change this to '.' for other locales
  RegExp regExp = RegExp(r'^\-?(\d+\.?\d*)?');
  String nums = '0123456789';

  String formatText(String text){
    //formatEditUpdate(oldValue, newValue)
    return "";
  }

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Short-circuit if the new value is empty
    if (newValue.text.length == 0) {
      return newValue.copyWith(text: '');
    }

    // Handle "deletion" of separator character
    String oldValueText = oldValue.text.replaceAll(separator, '');
    String newValueText = newValue.text.replaceAll(separator, '');

    String preformatted = '';

    bool hasMinus = false;
    bool hasPoint = false;
    for (int i = 0; i < newValueText.length; i++) {
      if (nums.contains(newValueText[i])) {
        preformatted += newValueText[i];
      } else if (newValueText[i] == '.' && !hasPoint) {
        if (oldValueText.isEmpty) {
          preformatted += '0.';
          hasPoint = true;
        } else if (!oldValueText.contains('.')) {
          preformatted += '.';
        } else if (oldValueText.indexOf('.') == i) {
          preformatted += '.';
        }
      } else if (newValueText[i] == '-') {
        if (hasMinus) {
          preformatted = preformatted.substring(1, preformatted.length);
          hasMinus = false;
        } else {
          if (oldValueText == '') {
            preformatted += '0';
          }
          preformatted = '-$preformatted';
          hasMinus = true;
        }
      }
    }

    newValueText = preformatted;

    if (oldValue.text.endsWith(separator) &&
        oldValue.text.length == newValue.text.length + 1) {
      newValueText = newValueText.substring(0, newValueText.length - 1);
    }

    String toFormat = '';
    String fractPart = '';
    for (int i = 0; i < preformatted.length; i++) {
      if (nums.contains(preformatted[i])) {
        toFormat += preformatted[i];
      } else if (preformatted[i] == '.') {
        fractPart += '.${preformatted.substring(i + 1, preformatted.length)}';
        break;
      }
    }

    int selectionIndex = newValue.text.length - newValue.selection.extentOffset;
    final chars = toFormat.split('');

    String newString = '';
    for (int i = chars.length - 1; i >= 0; i--) {
      if ((chars.length - 1 - i) % 3 == 0 && i != chars.length - 1) {
        newString = separator + newString;
      }
      newString = chars[i] + newString;
    }

    if (hasMinus) {
      newString = '-$newString';
    }

    return TextEditingValue(
      text: (newString + fractPart).toString(),
      selection: TextSelection.collapsed(
        offset: (newString + fractPart).length - selectionIndex,
      ),
    );
  }
}
