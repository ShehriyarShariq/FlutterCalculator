import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:math_expressions/math_expressions.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);

    return MaterialApp(
      title: 'Calculator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Calculator(), // Calculator Widget
    );
  }
}

class Calculator extends StatefulWidget {
  @override
  CalculatorState createState() => CalculatorState();
}

class CalculatorState extends State<Calculator> {
  String equation = "0"; // expression
  String result = "0"; // final result

  evaluateEquation() {
    try {
      Parser p = new Parser();

      // Fix equation
      String eq = equation.replaceAll("×", "*");
      eq = eq.replaceAll("÷", "/");
      eq = eq.replaceAll("−", "-");
      eq = eq.replaceAll("+", "+");
      Expression exp = p.parse(eq);

      ContextModel cm = ContextModel();
      double res = exp.evaluate(EvaluationType.REAL, cm);
      String resStr = res.toString();

      // Check if decimal can be written as integer
      if (resStr.indexOf(".") != -1) {
        String decimalPart = resStr.substring(resStr.indexOf(".") + 1);
        if (decimalPart == "0") {
          resStr = resStr.substring(0, resStr.indexOf("."));
        } else if (decimalPart.length > 4) {
          resStr = resStr.substring(0, resStr.indexOf(".") + 4);
        }
      }

      result = resStr;
    } catch (e) {
      result = "Error";
    }
  }

  buttonPressed(String text, bool isClear) {
    setState(() {
      if ((text == "×") && isClear) {
        equation = "0";
        result = "0";
      } else if (text == "⌫") {
        equation = equation.substring(0, equation.length - 1);
        if (equation == "") {
          equation = "0";
          result = "0";
        }

        String lastChar = equation.substring(equation.length - 1);

        // If last character is not an operator
        if (!((lastChar == "÷") ||
            (lastChar == "×") ||
            (lastChar == "−") ||
            (lastChar == "+"))) {
          evaluateEquation();
        }
      } else {
        if (equation == "0" && text != ".") {
          // 0.something...
          equation = text;
        } else {
          if (equation == "0" && text == "0") {
            equation = "";
          }

          equation += text;
        }

        // If new character not and operator
        if (!((text == "÷") ||
            (text == "×") ||
            (text == "−") ||
            (text == "+"))) {
          evaluateEquation();
        }
      }
    });
  }

  Widget button(text, Color color, double paddingBot) {
    return Container(
      width: MediaQuery.of(context).size.height * 0.57 * 0.1925,
      child: FlatButton(
        color: color,
        shape: CircleBorder(
            side: BorderSide(
                color: Color.fromRGBO(230, 230, 230, 1),
                width: 1,
                style: BorderStyle.solid)),
        onPressed: () => buttonPressed(text, false),
        child: Text(
          text,
          style: TextStyle(
            color: Color.fromRGBO(94, 94, 94, 1),
            fontSize: 40.0,
            fontWeight: FontWeight.w300,
          ),
        ),
        padding:
            EdgeInsets.all(MediaQuery.of(context).size.height * 0.57 * 0.04),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height * 0.12,
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.fromLTRB(22.5, 0, 5, 0),
                child: Row(
                  children: <Widget>[
                    Text(equation,
                        style: TextStyle(
                            fontSize:
                                (MediaQuery.of(context).size.height * 0.023) *
                                    2,
                            color: Color.fromRGBO(152, 152, 152, 1),
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.12,
                padding: EdgeInsets.fromLTRB(5, 0, 22.5, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () => buttonPressed("×", true),
                      child: Text(
                        "×",
                        style: TextStyle(
                            fontSize:
                                (MediaQuery.of(context).size.height * 0.03) * 2,
                            color: Color.fromRGBO(200, 200, 200, 1),
                            fontWeight: FontWeight.w300),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
          Container(
              margin: EdgeInsets.fromLTRB(
                  MediaQuery.of(context).size.width * 0.04,
                  0,
                  MediaQuery.of(context).size.width * 0.04,
                  0),
              decoration: BoxDecoration(
                  border: Border(
                bottom: BorderSide(color: Color.fromRGBO(227, 227, 227, 1)),
                left: BorderSide(color: Color.fromRGBO(227, 227, 227, 1)),
              ))),
          Container(
              height: MediaQuery.of(context).size.height * 0.31,
              alignment: Alignment.topLeft,
              child: Container(
                padding: EdgeInsets.fromLTRB(
                    MediaQuery.of(context).size.width * 0.04,
                    MediaQuery.of(context).size.height * 0.015,
                    MediaQuery.of(context).size.width * 0.04,
                    0),
                child: Text(
                  result,
                  style: TextStyle(
                      color: Color.fromRGBO(227, 227, 227, 1),
                      fontSize:
                          (((MediaQuery.of(context).size.height * 0.073) * 2) *
                                  72) /
                              96,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Chivo'),
                ),
              )),
          Expanded(
            child: Container(
              color: Color.fromRGBO(241, 241, 241, 1),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        height: MediaQuery.of(context).size.height * 0.55,
                        margin: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width * 0.02),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            button("7", Color.fromRGBO(230, 230, 230, 1), 5),
                            button("4", Color.fromRGBO(230, 230, 230, 1), 5),
                            button("1", Color.fromRGBO(230, 230, 230, 1), 5),
                            button("0", Color.fromRGBO(230, 230, 230, 1), 0),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        height: MediaQuery.of(context).size.height * 0.55,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            button("8", Color.fromRGBO(230, 230, 230, 1), 5),
                            button("5", Color.fromRGBO(230, 230, 230, 1), 5),
                            button("2", Color.fromRGBO(230, 230, 230, 1), 5),
                            button(".", Color.fromRGBO(230, 230, 230, 1), 0),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        height: MediaQuery.of(context).size.height * 0.55,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            button("9", Color.fromRGBO(230, 230, 230, 1), 5),
                            button("6", Color.fromRGBO(230, 230, 230, 1), 5),
                            button("3", Color.fromRGBO(230, 230, 230, 1), 5),
                            Container(
                              width: MediaQuery.of(context).size.height *
                                  0.57 *
                                  0.1925,
                              child: FlatButton(
                                color: Color.fromRGBO(230, 230, 230, 1),
                                shape: CircleBorder(
                                    side: BorderSide(
                                        color: Color.fromRGBO(230, 230, 230, 1),
                                        width: 1,
                                        style: BorderStyle.solid)),
                                onPressed: () => buttonPressed("⌫", false),
                                child: Text(
                                  "⌫",
                                  style: TextStyle(
                                    color: Color.fromRGBO(94, 94, 94, 1),
                                    fontSize: 34.5,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                                padding: EdgeInsets.all(
                                    MediaQuery.of(context).size.height *
                                        0.57 *
                                        0.04),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        height: MediaQuery.of(context).size.height * 0.55,
                        margin: EdgeInsets.only(
                            right: MediaQuery.of(context).size.width * 0.02),
                        decoration: new BoxDecoration(
                            color: Color.fromRGBO(237, 65, 53, 1),
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(100.0),
                                bottom: Radius.circular(100.0))),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              width: MediaQuery.of(context).size.height *
                                  0.57 *
                                  0.1925,
                              child: FlatButton(
                                color: Color.fromRGBO(237, 65, 53, 1),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(100.0))),
                                onPressed: () => buttonPressed("÷", false),
                                child: Text(
                                  "÷",
                                  style: TextStyle(
                                    color: Color.fromRGBO(255, 211, 215, 1),
                                    fontSize: 40.0,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                                padding: EdgeInsets.only(
                                    left: MediaQuery.of(context).size.height *
                                        0.57 *
                                        0.04,
                                    bottom: MediaQuery.of(context).size.height *
                                        0.57 *
                                        0.04,
                                    right: MediaQuery.of(context).size.height *
                                        0.57 *
                                        0.04,
                                    top: MediaQuery.of(context).size.height *
                                        0.57 *
                                        0.03),
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.height *
                                  0.57 *
                                  0.1925,
                              child: FlatButton(
                                color: Color.fromRGBO(237, 65, 53, 1),
                                onPressed: () => buttonPressed("×", false),
                                child: Container(
                                  child: Text(
                                    "×",
                                    style: TextStyle(
                                      color: Color.fromRGBO(255, 211, 215, 1),
                                      fontSize: 40.0,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                ),
                                padding: EdgeInsets.all(
                                    MediaQuery.of(context).size.height *
                                        0.57 *
                                        0.04),
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.height *
                                  0.57 *
                                  0.1925,
                              child: FlatButton(
                                color: Color.fromRGBO(237, 65, 53, 1),
                                onPressed: () => buttonPressed("−", false),
                                child: Container(
                                  child: Text(
                                    "−",
                                    style: TextStyle(
                                      color: Color.fromRGBO(255, 211, 215, 1),
                                      fontSize: 40.0,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                ),
                                padding: EdgeInsets.all(
                                    MediaQuery.of(context).size.height *
                                        0.57 *
                                        0.04),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(
                                  bottom:
                                      MediaQuery.of(context).size.width * 0.02),
                              width: MediaQuery.of(context).size.height *
                                  0.57 *
                                  0.1925,
                              child: FlatButton(
                                color: Color.fromRGBO(237, 65, 53, 1),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                      bottom: Radius.circular(100.0)),
                                ),
                                onPressed: () => buttonPressed("+", false),
                                child: Text(
                                  "+",
                                  style: TextStyle(
                                    color: Color.fromRGBO(255, 211, 215, 1),
                                    fontSize: 40.0,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                                padding: EdgeInsets.only(
                                    left: MediaQuery.of(context).size.height *
                                        0.57 *
                                        0.04,
                                    bottom: MediaQuery.of(context).size.height *
                                        0.57 *
                                        0.02,
                                    right: MediaQuery.of(context).size.height *
                                        0.57 *
                                        0.04,
                                    top: MediaQuery.of(context).size.height *
                                        0.57 *
                                        0.04),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
