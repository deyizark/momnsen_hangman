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
        title: Text("Jeu du Pendu"),
        centerTitle: true,
      ),
      body: Center(
        child: ElevatedButton(
          child: Text("Commencer le jeu"),
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
    {"word": "FLUTTER", "hint": "Framework pou app mobil"},
  ];

  String secretWord = "";
  String hint = "";
  List<String> hiddenWord = [];
  int chances = 5;
  List<String> usedLetters = [];
  final _random = Random();

  @override
  void initState() {
    super.initState();
    startGame();
  }

  void startGame() {
    final wordData = words[_random.nextInt(words.length)];
    secretWord = wordData["word"]!;
    hint = wordData["hint"]!;
    hiddenWord = List.generate(secretWord.length, (_) => "*");
    chances = 5;
    usedLetters = [];
    setState(() {});
  }

  void checkLetter(String letter) {
    if (usedLetters.contains(letter)) return;

    setState(() {
      usedLetters.add(letter);

      if (secretWord.contains(letter)) {
        for (int i = 0; i < secretWord.length; i++) {
          if (secretWord[i] == letter) hiddenWord[i] = letter;
        }
      } else {
        chances--;
      }
    });

    if (!hiddenWord.contains("*")) goToResult(true);
    else if (chances == 0) goToResult(false);
  }

  void goToResult(bool win) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => ResultScreen(win: win)),
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
                Icon(Icons.star, color: Colors.yellow),
                SizedBox(width: 4),
                Text("$chances", style: TextStyle(fontSize: 18)),
              ],
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text(hint, style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic)),
            SizedBox(height: 20),
            Text(hiddenWord.join(" "), style: TextStyle(fontSize: 32, letterSpacing: 2)),
            SizedBox(height: 20),
            Expanded(child: buildKeyboard()),
          ],
        ),
      ),
    );
  }

  // =======================
  // RESPONSIVE QWERTY KEYBOARD
  // =======================
  Widget buildKeyboard() {
    const row1 = ["Q","W","E","R","T","Y","U","I","O","P"];
    const row2 = ["A","S","D","F","G","H","J","K","L"];
    const row3 = ["Z","X","C","V","B","N","M"];

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        buildKeyboardRow(row1),
        SizedBox(height: 5),
        buildKeyboardRow(row2),
        SizedBox(height: 5),
        buildKeyboardRow(row3),
      ],
    );
  }

  Widget buildKeyboardRow(List<String> letters) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: letters.map((letter) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: ElevatedButton(
              onPressed: usedLetters.contains(letter) ? null : () => checkLetter(letter),
              child: Text(letter),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(0, 50), // lajè adapte otomatik
                padding: EdgeInsets.zero,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

// =======================
// RESULT SCREEN
// =======================
class ResultScreen extends StatelessWidget {
  final bool win;
  const ResultScreen({required this.win});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(win ? "🎉 Ou Genyen !" : "❌ Ou Pèdi",
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
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