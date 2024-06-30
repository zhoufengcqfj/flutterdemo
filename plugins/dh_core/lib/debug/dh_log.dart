
/// @Author 90196
/// @DateTime 2021/5/31 14:29
/// @Description: 项目统一日志输出
class Log {
  static String _prefix = "--->";

  static bool _debug = true;

  static setDebug(bool debug) {
    _debug = debug;
  }

  static void it(String tag, String info) {
    _i(tag, info);
  }

  static void i(String info) {
    _i(null, info);
  }

  static void e(String info) {
    _e(null, info);
  }

  static void _i(String? tag, String info) {
    if (_debug) {
      if (tag == null) {
        _show("$_prefix", info);
      } else {
        _show("$_prefix$tag", info);
      }
    }
  }

  static void _e(String? tag, String info) {
    if (tag == null) {
      _show("$_prefix", info);
    } else {
      _show("$_prefix$tag", info);
    }
  }

  static void _show(String tag, String msg) {
    msg = msg.trim();
    int index = 0;
    int segmentSize = 960;
    String logContent;
    while (index < msg.length) {
      if (msg.length <= index + segmentSize) {
        logContent = msg.substring(index);
      } else {
        logContent = msg.substring(index, segmentSize + index);
      }
      index += segmentSize;
      print("$tag, $logContent");
    }
  }

  static void iList(List? list, {String? tag}) {
    if (list != null) {
        list.forEach((element) {
          _i(tag, element.toString());
        });
    }
  }
}
