abstract class OpenCloseFinder {
  late int _openCount;
  late int _closeCount;
  late RegExp _openRegExp;
  late RegExp _closeRegExp;
  late bool _reverse;
  late bool _debug;

  OpenCloseFinder(RegExp openRegExp, RegExp closeRegExp,
      {bool reverse = false, bool debug = false}) {
    _openCount = 0;
    _closeCount = 0;
    this._reverse = reverse;
    this._debug = debug;
    if (reverse) {
      this._openRegExp = closeRegExp;
      this._closeRegExp = openRegExp;
    } else {
      this._openRegExp = openRegExp;
      this._closeRegExp = closeRegExp;
    }
  }

  bool _isDirty() {
    return _openCount != _closeCount;
  }

  void _incrementOpen(int number) {
    _openCount += number;
  }

  void _incrementClose(int number) {
    _closeCount += number;
  }

  void _decrementOpen(int number) {
    _openCount -= number;
  }

  void _decrementClose(int number) {
    _closeCount -= number;
  }

  void _logDebug(String message) {
    if (_debug) {
      print(message);
    }
  }

  String run(String fileContent, String className) {
    reset();
    final lines = fileContent.split('\n');
    String classContent = '';
    bool start = false;
    for (final line in lines) {
      _logDebug('====${className}====');
      if (line.startsWith("sealed class $className") ||
          line.startsWith("class $className")) {
        start = true;
        _logDebug('========');
        _logDebug('start');
      }
      if (start) {
        _logDebug('========');
        _logDebug('start');
        var matchesOpen = this._openRegExp.allMatches(line);
        _logDebug('========');
        _logDebug('matchOpen ${matchesOpen.length}');
        var matchesClose = this._closeRegExp.allMatches(line);
        _logDebug('========');
        _logDebug('matchClose ${matchesClose.length}');
        _incrementOpen(matchesOpen.length);
        _incrementClose(matchesClose.length);
        if (_isDirty()) {
          classContent += line + '\n';
          _logDebug('========');
          _logDebug('classContent $classContent');
        } else {
          classContent += line + '\n';
          break;
        }
      }
    }
    _logDebug('========');
    _logDebug(classContent);
    return classContent;
  }

  void reset() {
    _openCount = 0;
    _closeCount = 0;
  }
}

class BigOpenCloseFinder extends OpenCloseFinder {
  BigOpenCloseFinder({bool debug = false})
      : super(RegExp(r'{'), RegExp(r'}'), reverse: false, debug: debug);
}
