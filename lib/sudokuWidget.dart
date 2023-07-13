import 'dart:math';

import 'package:flutter/material.dart';
// import 'package:gaming/constants.dart';
import 'package:quiver/iterables.dart';
import 'package:gaming/blokChar.dart';
import 'package:gaming/boxInner.dart';
import 'package:gaming/focusClass.dart';
import 'package:sudoku_solver_generator/sudoku_solver_generator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gaming/size_config.dart';

class SudokuWidget extends StatefulWidget {
  SudokuWidget({
    Key? key,
    this.sudokuAppBar,
    this.outerBorderColor = Colors.black,
    this.finishedSudokuBlockFG = Colors.white,
    this.sudokuBlockFG,
    this.sudokuBlockBG,
    this.scaffoldBG = Colors.white,
    this.emptyCellBG,
    this.solvedSudokuBG,
    this.highlightedCellsBG,
    this.selectedCellBG,
    this.buttonFG = Colors.black,
    this.buttonBG,
  }) : super(key: key);

  AppBar? sudokuAppBar;

  Color defaultBlack = Colors.black;
  Color defaultWhite = Colors.white;
  Color defaultTransparent = Colors.transparent;
  Color defaultRed = Colors.red;

  Color? outerBorderColor = Colors.black;
  Color? finishedSudokuBlockFG = Colors.white;
  Color? sudokuBlockFG;
  Color? sudokuBlockBG;
  Color? scaffoldBG = Colors.white;
  Color? emptyCellBG;
  Color? solvedSudokuBG;
  Color? highlightedCellsBG;
  Color? selectedCellBG;

  Color? buttonBG = Colors.grey.shade50;
  Color? buttonFG = Colors.black;

  @override
  State<SudokuWidget> createState() => _SudokuWidgetState();
}

class _SudokuWidgetState extends State<SudokuWidget> {
  // our variable
  List<BoxInner> boxInners = [];
  FocusClass focusClass = FocusClass();
  bool isFinish = false;
  String? tapBoxIndex;

  @override
  void initState() {
    generateSudoku();

    // TODO: implement initState
    super.initState();
  }

  void generateSudoku() {
    isFinish = false;
    focusClass = new FocusClass();
    tapBoxIndex = null;
    generatePuzzle();
    checkFinish();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    // var checkFinish = isFinish;
    // if (checkFinish) {
    //   showDialog(
    //       context: context,
    //       builder: (_) => AlertDialog(
    //             title: const Text("What's New / Que ha Cambiado"),
    //             content: Text("You have successfully completed the Sudoku"),
    //             actions: <Widget>[
    //               TextButton(
    //                 child: const Text("OK"),
    //                 onPressed: () {
    //                   // Navigator.of(context).pop();
    //                 },
    //               )
    //             ],
    //           ));
    // }

    // lets put on ui
    return SafeArea(
      child: Scaffold(
        appBar: widget.sudokuAppBar ??
            AppBar(
              iconTheme: IconThemeData(color: widget.defaultBlack),
              actions: [
                TextButton(
                  onPressed: () => generateSudoku(),
                  style: TextButton.styleFrom(
                      backgroundColor: widget.defaultTransparent),
                  child: Icon(
                    Icons.refresh,
                    color: widget.defaultBlack,
                    size: getProportionateScreenWidth(24),
                  ),
                ),
              ],
              title: Text(
                "Sudoku",
                style: GoogleFonts.darkerGrotesque(
                    fontWeight: FontWeight.w900,
                    fontSize: getProportionateScreenWidth(30),
                    color: Colors.black),
              ),
              // elevation: 0,
              toolbarHeight: 70,
              backgroundColor: widget.scaffoldBG,
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(0.0),
                child: Container(
                  height: 3,
                  alignment: Alignment.bottomCenter,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: <Color>[
                        Color(0xFF019688),
                        Color(0xFF183263),
                        // Color(0xff1f2046),
                        Color(0xFFbb1819),
                        Color(0xFFfd8601)
                      ],
                    ),
                  ),
                ),
              ),
              centerTitle: true,
              // automaticallyImplyLeading: true,
            ),
        backgroundColor: widget.defaultWhite,
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(
              vertical: getProportionateScreenHeight(20),
            ),
            alignment: Alignment.center,
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.all(getProportionateScreenWidth(20)),
                  // height: 400,
                  color: widget.outerBorderColor,
                  padding: const EdgeInsets.all(2.5),
                  width: double.maxFinite,
                  alignment: Alignment.center,
                  child: GridView.builder(
                    itemCount: boxInners.length,
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 1,
                      crossAxisSpacing: 2,
                      mainAxisSpacing: 2,
                    ),
                    physics: const ScrollPhysics(),
                    itemBuilder: (buildContext, index) {
                      BoxInner boxInner = boxInners[index];

                      return Container(
                        color: widget.sudokuBlockBG ?? Colors.red.shade600,
                        alignment: Alignment.center,
                        child: GridView.builder(
                          itemCount: boxInner.blokChars.length,
                          shrinkWrap: true,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            childAspectRatio: 1,
                            crossAxisSpacing: 1.5,
                            mainAxisSpacing: 1.5,
                          ),
                          physics: const ScrollPhysics(),
                          itemBuilder: (buildContext, indexChar) {
                            BlokChar blokChar = boxInner.blokChars[indexChar];
                            Color? color =
                                widget.emptyCellBG ?? Colors.yellow.shade100;
                            Color? colorText = widget.sudokuBlockFG ??
                                const Color.fromARGB(255, 55, 55, 55);

                            // change color base condition

                            if (isFinish) {
                              color = widget.solvedSudokuBG ??
                                  const Color.fromARGB(255, 75, 181, 67);
                              // showDialog(
                              //   context: context,
                              //   builder: (ctx) => AlertDialog(
                              //     title: const Text("Alert Dialog Box"),
                              //     content: const Text(
                              //         "You have raised a Alert Dialog Box"),
                              //     actions: <Widget>[
                              //       TextButton(
                              //         onPressed: () {
                              //           Navigator.of(ctx).pop();
                              //         },
                              //         child: Container(
                              //           color: Colors.green,
                              //           padding: const EdgeInsets.all(14),
                              //           child: const Text("okay"),
                              //         ),
                              //       ),
                              //     ],
                              //   ),
                              // );
                            } else if (blokChar.isFocus &&
                                blokChar.text != "") {
                              color = widget.highlightedCellsBG ??
                                  const Color.fromARGB(255, 226, 246, 131);
                            } else if (blokChar.isDefault) {
                              color = widget.defaultWhite;
                            }

                            if (tapBoxIndex == "${index}-${indexChar}" &&
                                !isFinish) {
                              color =
                                  widget.selectedCellBG ?? Colors.grey.shade300;
                            }

                            if (isFinish) {
                              colorText = widget.finishedSudokuBlockFG;
                            } else if (blokChar.isExist) {
                              colorText = widget.defaultRed;
                            }

                            return Container(
                              // padding: EdgeInsets.all(1),
                              color: color,
                              alignment: Alignment.center,
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.all(0),
                                ),
                                onPressed: blokChar.isDefault
                                    ? null
                                    : () => setFocus(index, indexChar),
                                child: Text(
                                  "${blokChar.text}",
                                  style: TextStyle(
                                    color: colorText,
                                    fontSize: getProportionateScreenWidth(20),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(getProportionateScreenWidth(20)),
                  alignment: Alignment.center,
                  child: Column(
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        // crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          for (int i = 1; i <= 9; i++)
                            SizedBox(
                              width: getProportionateScreenWidth(32),
                              child: ElevatedButton(
                                // style: ElevatedButton.styleFrom(padding: EdgeInsets.all(5)),
                                onPressed: () => setInput(i),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      widget.buttonBG ?? Colors.grey.shade50,
                                  padding: EdgeInsets.symmetric(
                                    vertical: getProportionateScreenHeight(12),
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  side: BorderSide(
                                    width: getProportionateScreenHeight(1),
                                  ),
                                ),
                                child: Text(
                                  "${i}",
                                  style: TextStyle(
                                    color: widget.buttonFG,
                                    fontSize: getProportionateScreenWidth(18),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                      SizedBox(
                        height: getProportionateScreenHeight(12),
                      ),
                      SizedBox(
                        width: getProportionateScreenWidth(100),
                        child: ElevatedButton(
                          // style: ElevatedButton.styleFrom(padding: EdgeInsets.all(5)),
                          onPressed: () => setInput(null),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                widget.buttonBG ?? Colors.grey.shade50,
                            padding: EdgeInsets.symmetric(
                              vertical: getProportionateScreenHeight(12),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            side: BorderSide(
                              width: getProportionateScreenWidth(1),
                            ),
                          ),
                          child: Text(
                            "Clear",
                            style: TextStyle(
                              color: widget.buttonFG,
                              fontSize: getProportionateScreenWidth(18),
                            ),
                          ),
                        ),
                      ),
                      // ElevatedButton(
                      // isFinish ?
                      //   showDialog(
                      //     context: context,
                      //     builder: (ctx) => AlertDialog(
                      //       title: const Text("Alert Dialog Box"),
                      //       content: const Text(
                      //           "You have raised a Alert Dialog Box"),
                      //       actions: <Widget>[
                      //         TextButton(
                      //           onPressed: () {
                      //             Navigator.of(ctx).pop();
                      //           },
                      //           child: Container(
                      //             color: Colors.green,
                      //             padding: const EdgeInsets.all(14),
                      //             child: const Text("okay"),
                      //           ),
                      //         ),
                      //       ],
                      //     ),
                      //   );
                      // },
                      //   child: const Text("Show alert Dialog box"),
                      // ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  generatePuzzle() {
    // install plugins sudoku generator to generate one
    boxInners.clear();
    var sudokuGenerator = SudokuGenerator(emptySquares: 27); //54
    // then we populate to get a possible cmbination
    // Quiver for easy populate collection using partition
    List<List<List<int>>> completes = partition(sudokuGenerator.newSudokuSolved,
            sqrt(sudokuGenerator.newSudoku.length).toInt())
        .toList();
    partition(sudokuGenerator.newSudoku,
            sqrt(sudokuGenerator.newSudoku.length).toInt())
        .toList()
        .asMap()
        .entries
        .forEach(
      (entry) {
        List<int> tempListCompletes =
            completes[entry.key].expand((element) => element).toList();
        List<int> tempList = entry.value.expand((element) => element).toList();

        tempList.asMap().entries.forEach((entryIn) {
          int index =
              entry.key * sqrt(sudokuGenerator.newSudoku.length).toInt() +
                  (entryIn.key % 9).toInt() ~/ 3;

          if (boxInners.where((element) => element.index == index).length ==
              0) {
            boxInners.add(BoxInner(index, []));
          }

          BoxInner boxInner =
              boxInners.where((element) => element.index == index).first;

          boxInner.blokChars.add(BlokChar(
            entryIn.value == 0 ? "" : entryIn.value.toString(),
            index: boxInner.blokChars.length,
            isDefault: entryIn.value != 0,
            isCorrect: entryIn.value != 0,
            correctText: tempListCompletes[entryIn.key].toString(),
          ));
        });
      },
    );

    // complte generate puzzle sudoku
  }

  setFocus(int index, int indexChar) {
    tapBoxIndex = "$index-$indexChar";
    focusClass.setData(index, indexChar);
    showFocusCenterLine();
    setState(() {});
  }

  void showFocusCenterLine() {
    // set focus color for line vertical & horizontal
    int rowNoBox = focusClass.indexBox! ~/ 3;
    int colNoBox = focusClass.indexBox! % 3;

    this.boxInners.forEach((element) => element.clearFocus());

    boxInners.where((element) => element.index ~/ 3 == rowNoBox).forEach(
        (e) => e.setFocus(focusClass.indexChar!, Direction.Horizontal));

    boxInners
        .where((element) => element.index % 3 == colNoBox)
        .forEach((e) => e.setFocus(focusClass.indexChar!, Direction.Vertical));
  }

  setInput(int? number) {
    // set input data based grid
    // or clear out data
    if (focusClass.indexBox == null) return;
    if (boxInners[focusClass.indexBox!].blokChars[focusClass.indexChar!].text ==
            number.toString() ||
        number == null) {
      boxInners.forEach((element) {
        element.clearFocus();
        element.clearExist();
      });
      boxInners[focusClass.indexBox!]
          .blokChars[focusClass.indexChar!]
          .setEmpty();
      tapBoxIndex = null;
      isFinish = false;
      showSameInputOnSameLine();
    } else {
      boxInners[focusClass.indexBox!]
          .blokChars[focusClass.indexChar!]
          .setText("$number");

      showSameInputOnSameLine();

      checkFinish();
    }

    setState(() {});
  }

  void showSameInputOnSameLine() {
    // show duplicate number on same line vertical & horizontal so player know he or she put a wrong value on somewhere

    int rowNoBox = focusClass.indexBox! ~/ 3;
    int colNoBox = focusClass.indexBox! % 3;

    String textInput =
        boxInners[focusClass.indexBox!].blokChars[focusClass.indexChar!].text!;

    boxInners.forEach((element) => element.clearExist());

    boxInners.where((element) => element.index ~/ 3 == rowNoBox).forEach((e) =>
        e.setExistValue(focusClass.indexChar!, focusClass.indexBox!, textInput,
            Direction.Horizontal));

    boxInners.where((element) => element.index % 3 == colNoBox).forEach((e) =>
        e.setExistValue(focusClass.indexChar!, focusClass.indexBox!, textInput,
            Direction.Vertical));

    List<BlokChar> exists = boxInners
        .map((element) => element.blokChars)
        .expand((element) => element)
        .where((element) => element.isExist)
        .toList();

    if (exists.length == 1) exists[0].isExist = false;
  }

  void checkFinish() {
    int totalUnfinish = boxInners
        .map((e) => e.blokChars)
        .expand((element) => element)
        .where((element) => !element.isCorrect)
        .length;

    isFinish = totalUnfinish == 0;
  }
}
