class MyList<E> {
  final List<E> _items = [];
  int _curPos = 0;
  E getNextItem() {
    return _items[++_curPos % _items.length];
  }

  void writeCurrentItem(E value) {
    _items[_curPos] = value;
  }

  void advancePointer() {
    ++_curPos;
  }

  E getPreviousItem() {
    return _items[(--_curPos) % _items.length];
  }

  void decrementPointer() {
    --_curPos;
  }

  int length() {
    return _items.length;
  }

  void setLocation(int location) {
    _curPos = location % _items.length;
  }
}

class GameList extends MyList<int> {
  List<List<int>> convertToNormalForm(int p) {
    List<List<int>> rv = [];
    for (int i = 0; i < 2; i++) {
      List<int> r = [];
      for (int j = 0; j < p; j++) {
        r.add(_items[(i * p) + p]);
      }
      rv.add(r);
    }
    return rv;
  }

  GameList();

  GameList.init(List<List<int>> l) {
    for (int i = 0; i < l.length; i++) {
      for (int j = 0; j < l[i].length; j++) {
        _items.add(l[i][j]);
      }
    }
  }
}
