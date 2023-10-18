import 'package:big_decimal/big_decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
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

    first = firstTextController!.text;
    second = secondTextController!.text;
  }

  void onButtonMinus() {
    setValues();
    result = BigDecimal.parse(first) - BigDecimal.parse(second);
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
              TextField(
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\-?(\d+\.?\d*)?')),
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
                ],
              ),
              TextField(
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\-?(\d+\.?\d*)?')),
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
