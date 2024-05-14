
class DataBaseHandler {
  static final DataBaseHandler _instance = DataBaseHandler._internal();

  factory DataBaseHandler() {
    return _instance;
  }

  DataBaseHandler._internal();

}
