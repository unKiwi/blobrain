// ignore_for_file: prefer_typing_uninitialized_variables

class Data {
  // user
  static late String id;
  static String type = "user";
  static late List lsUser;
  static late List lsInvite;
  static bool inGame = true;

  // level
  static late int level;
  static late double percent;

  // timer
  static late int timerSeconds;
  static late int timeToReset;

  // pion
  static late int currentShape;
  static late int currentColor;

  static List lsShape = ['shape', 'circle', 'triangle', 'square', 'pentagone', 'hexagone'];
  static List lsColor = ['#313954', '#c62828', '#f9a825', '#1565c0', '#2e7d32', '#7b38a2'];

  // grid
  static late String grid;
  static late String movePlayed;
  static late int cote;
  static late List pionFix;
  static late List pionVar;
  static late var error;

  static void updateGameState(data) {
    grid = data['grid'];
    movePlayed = data['movePlayed'];
    level = data['level'];
    percent = double.parse(data['nextLevel'].toString());
    timerSeconds = data['timer'];

    parseGrid();
  }

  static void parseGrid() {
    var splited = grid.split(' ');
    cote = int.parse(splited[0]);

    currentColor = (cote / 2).truncate();
    currentShape = (cote / 2).truncate();
    error = null;

    pionVar = [];
    pionFix = [];

    for (int i = 1; i < splited.length; i++) {
      pionFix.add({'x': int.parse(splited[i][0]) - 1, 'y': int.parse(splited[i][1]) - 1, 'color': int.parse(splited[i][2]), 'shape': int.parse(splited[i][3])});
    }
    
    if (movePlayed != "") {
      splited = movePlayed.split(' ');
      for (int i = 0; i < splited.length; i++) {
        pionVar.add({'x': int.parse(splited[i][0]) - 1, 'y': int.parse(splited[i][1]) - 1, 'color': int.parse(splited[i][2]), 'shape': int.parse(splited[i][3])});
      }
    }
  }
}