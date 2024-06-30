///日志输出
class Log {

  //log输出
  static void log(String info) {
    print("[AUTO-NET] $info");
  }

  //log输出
  static void err(String info) {
    // print('\033[31m[AUTO-NET] $info \033[0m');
    print('[AUTO-NET] $info');
  }

}