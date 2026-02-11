import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Deyizark_Hangman"),
        centerTitle: true,
      ),
      body: Center(
        child: ElevatedButton(
          child: Text("Kòmanse Jwe..."),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => GameScreen()),
            );
          },
        ),
      ),
    );
  }
}

class GameScreen extends StatefulWidget {
  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final List<Map<String, String>> words = [
    {"word": "BONJOU", "hint": "Mo pou salye moun"},
    {"word": "DART", "hint": "Langaj Flutter itilize"},
    {"word": "FLUTTER", "hint": "Framework pou apk mobil"},
    {"word": "VARYAB", "hint": "Espas pou estoke done nan pwogram"},
    {"word": "FONKSYON", "hint": "Blòk kòd ki fè yon travay presi"},
    {"word": "WIDJET", "hint": "Eleman bazik nan Flutter"},
    {"word": "PYTHON", "hint": "Langaj pwogramasyon popilè bokouu"},
    {"word": "BACKUP", "hint": "Sovgad nan mitan pwojè"},
    {"word": "ESIH", "hint": "It's not easy"},
  ];

  String moSekre = "";
  String hint = "";
  List<String> moKache = [];
  int chans = 5;
  List<String> letDejaItilize = [];
  final _random = Random();

  @override
  void initState() {
    super.initState();
    startGame();
  }

  void startGame() {
    final wordData = words[_random.nextInt(words.length)];
    moSekre = wordData["word"]!;
    hint = wordData["hint"]!;
    moKache = List.generate(moSekre.length, (_) => "*");
    chans = 5;
    letDejaItilize = [];
    setState(() {});
  }

  void checkLetter(String let) {
    if (letDejaItilize.contains(let)) return;

    setState(() {
      letDejaItilize.add(let);

      if (moSekre.contains(let)) {
        for (int i = 0; i < moSekre.length; i++) {
          if (moSekre[i] == let) {
            moKache[i] = let;
          }
        }
      } else {
        chans--;
      }
    });

    if (!moKache.contains("*")) {
      goToResult(true);
    } else if (chans == 0) {
      goToResult(false);
    }
  }

  void goToResult(bool genyen) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => ResultScreen(genyen: genyen)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hangman"),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text("$chans", style: TextStyle(fontSize: 18)),
                SizedBox(width: 4),
                Icon(Icons.favorite, color: Colors.red),
              ],
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              moKache.join(" "),
              style: TextStyle(fontSize: 32, letterSpacing: 2),
            ),
            SizedBox(height: 10),
            Text(
              hint,
              style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Expanded(child: buildKeyboard()),
          ],
        ),
      ),
    );
  }

  Widget buildKeyboard() {
    const row1 = ["Q","W","E","R","T","Y","U","I","O","P"];
    const row2 = ["A","S","D","F","G","H","J","K","L"];
    const row3 = ["Z","X","C","V","B","N","M"];

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        buildKeyboardRow(row1, 1),
        SizedBox(height: 6),
        buildKeyboardRow(row2, 0.9),
        SizedBox(height: 6),
        buildKeyboardRow(row3, 0.8),
      ],
    );
  }

  Widget buildKeyboardRow(List<String> letters, double widthFactor) {
    return FractionallySizedBox(
      widthFactor: widthFactor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: letters.map((let) {
          return Flexible(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: ElevatedButton(
                onPressed: letDejaItilize.contains(let)
                    ? null
                    : () => checkLetter(let),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 48),
                  padding: EdgeInsets.zero,
                ),
                child: Text(let),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class ResultScreen extends StatelessWidget {
  final bool genyen;
  const ResultScreen({required this.genyen});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              genyen ? "BRAVO! Ou Genyen :)" : "Woy! Ou Pèdi",
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  child: Text("Rejwe"),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => GameScreen()),
                    );
                  },
                ),
                SizedBox(width: 16),
                ElevatedButton(
                  child: Text("Kite"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}