import 'package:flutter/material.dart';

void main() {
  runApp(TicTacToeApp());
}

class TicTacToeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TicTacToeGame(),
    );
  }
}

class TicTacToeGame extends StatefulWidget {
  @override
  _TicTacToeGameState createState() => _TicTacToeGameState();
}

class _TicTacToeGameState extends State<TicTacToeGame> {
  late List<List<String>> board;
  late String currentPlayer;
  late bool isGameFinished;

  @override
  void initState() {
    super.initState();
    resetGame();
  }

  void resetGame() {
    board = List.generate(3, (_) => List.generate(3, (_) => ''));
    currentPlayer = 'X';
    isGameFinished = false;
  }

  void makeMove(int row, int col) {
    if (board[row][col] == '' && !isGameFinished) {
      setState(() {
        board[row][col] = currentPlayer;
        checkWinner(row, col);
        togglePlayer();
      });
    }
  }

  void checkWinner(int row, int col) {
    String cellValue = board[row][col];

    // Check for a winner in the row
    if (board[row].every((value) => value == cellValue)) {
      isGameFinished = true;
      showWinnerDialog(cellValue);
      return;
    }

    // Check for a winner in the column
    if (board.every((row) => row[col] == cellValue)) {
      isGameFinished = true;
      showWinnerDialog(cellValue);
      return;
    }

    // Check for a winner in the main diagonal
    if (row == col && board.every((row) => row[col] == cellValue)) {
      isGameFinished = true;
      showWinnerDialog(cellValue);
      return;
    }

    // Check for a winner in the secondary diagonal
    if (row + col == 2 && board.every((row) => row[2 - col] == cellValue)) {
      isGameFinished = true;
      showWinnerDialog(cellValue);
    }

    // Check for a draw
    if (!board.any((row) => row.any((cell) => cell == '')) && !isGameFinished) {
      isGameFinished = true;
      showDrawDialog();
    }
  }

  void togglePlayer() {
    currentPlayer = currentPlayer == 'X' ? 'O' : 'X';
  }

  void showWinnerDialog(String winner) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Winner!'),
          content: Text('Player $winner wins!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                resetGame();
              },
              child: Text('Play Again'),
            ),
          ],
        );
      },
    );
  }

  void showDrawDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Draw!'),
          content: Text('The game is a draw.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                resetGame();
              },
              child: Text('Play Again'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tic Tac Toe'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (int i = 0; i < 3; i++)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (int j = 0; j < 3; j++)
                    GestureDetector(
                      onTap: () => makeMove(i, j),
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                        ),
                        child: Center(
                          child: Text(
                            board[i][j],
                            style: TextStyle(fontSize: 40),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            SizedBox(height: 20),
            if (isGameFinished)
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    resetGame();
                  });
                },
                child: Text('Play Again'),
              ),
          ],
        ),
      ),
    );
  }
}
