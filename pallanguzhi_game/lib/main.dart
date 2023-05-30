import 'package:flutter/material.dart';
import 'package:pallanguzhi_game/cll.dart';

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
  GameList gl = GameList();

  List<List<int>>? doGameTransition(int idx) {
    const p = 7;
    if (gl.length() == 0) {
      // game has not started yet!
      return null;
    } else {
      if (curTurn) {
        int numIters = countB[idx];
        gl.setLocation(p + idx);
        for (int i = 0; i < numIters; i++) {
          int item = gl.getNextItem();
          gl.writeCurrentItem(item + 1);
        }
      } else {
        int numIters = countA[idx];
        gl.setLocation(idx);
        for (int i = 0; i < numIters; i++) {
          int item = gl.getPreviousItem();
          gl.writeCurrentItem(item + 1);
        }
      }
      return gl.convertToNormalForm(p);
    }
  }

  void onClickButton(int idx) {
    var normalizedScheme = doGameTransition(idx);
    if (normalizedScheme != null) {
      setState(() {
        countA = normalizedScheme[0];
        countB = normalizedScheme[1];
        curTurn = !curTurn;
      });
    }
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
    gl = GameList.init([countA, countB]);
  }

  List<Widget> renderRow(List<int> l, bool modifier) {
    List<Widget> rv = [];
    for (var i = 0; i < l.length; i++) {
      if (i == 3) {
        rv.add(TextButton(
          onPressed: () => {},
          child: Text(l[i].toString()),
        ));
      }
      rv.add(TextButton(
        onPressed: () =>
            {modifier && curTurn && gl.length() > 0 ? onClickButton(i) : null},
        child: Text(l[i].toString()),
      ));
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
            children: renderRow(countA, false),
          ),
          Row(
            children: renderRow(countB, true),
          ),
          FilledButton(onPressed: startGame, child: const Text("Start Gamet")),
          Text("Current Turn is : ${curTurn ? "Down" : "Up"}",
              style: Typography.englishLike2021.headlineSmall)
        ],
      ),
    ));
  }
}
