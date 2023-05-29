import 'dart:developer';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
      // home: ,
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<int> countA = [0, 0, 0, 0, 0, 0, 0];
  List<int> countB = [0, 0, 0, 0, 0, 0, 0];
  int valueA = 36;
  int valueB = 36;
  bool isGameRunning = false;
  bool curTurn = false;

  void onClickButton(int idx, int key) {
    List<List<int>> normalizedScheme = [countA, countB];
    int numIters = normalizedScheme[key][idx];
    if (idx == 3 || ((key > 0) ^ curTurn) || (numIters == 0)) {
      // bank, other player, empty set

      return;
    } else {
      normalizedScheme[key][idx] = 0;
      int curKey = key;
      int curIdx = idx + 1;
      for (var i = 0; i < numIters; i++) {
        if (curIdx > 6) {
          curIdx = curIdx - 7;
          curKey = curKey > 0 ? 0 : 1;
        }
        log("curKey: $curKey, curIdx: $curIdx");
        normalizedScheme[curKey][curIdx]++;
        curIdx++;
      }
    }
    setState(() {
      countA = normalizedScheme[0];
      countB = normalizedScheme[1];
      curTurn = !curTurn;
    });
  }

  void startGameForPlayer(int count, List<int> board) {
    setState(() {
      for (var i = 0; i < 7 && count >= 6; i++) {
        if (i != 3) {
          count -= 6;
          board[i] = 6;
        }
      }
    });
  }

  void startGame() {
    startGameForPlayer(valueA, countA);
    startGameForPlayer(valueB, countB);
  }

  List<Widget> renderRow(List<int> l, int key) {
    List<Widget> rv = [];
    for (var i = 0; i < l.length; i++) {
      rv.add(TextButton(
          onPressed: () => {onClickButton(i, key)},
          child: Text(l[i].toString())));
    }
    return rv;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
      alignment: Alignment.center,
      child: Column(
        children: [
          Row(
            children: renderRow(countA, 0),
          ),
          Row(
            children: renderRow(countB, 1),
          ),
          FilledButton(onPressed: startGame, child: const Text("Start Gamet")),
          Text("Current Turn is : ${curTurn ? "Down" : "Up"}",
              style: Typography.englishLike2021.headlineSmall)
        ],
      ),
    ));
  }
}
