import 'dart:async';
import 'dart:io';

/// @Author 90196
/// @DateTime 2021/5/11 10:59
/// @Description: 打包脚本
/// 生成代码入口
///
/// 需要生成autoNet的模块
var autoNetModule = [
  // "./",
  // "./plugins/map",
  // "./plugins/tree",
  // "./plugins/vbd",
  // "./plugins/user",
  // "./plugins/message_center",
  // "./plugins/place",
  "./plugins/device_manager",
  // "./plugins/mine",
  "./plugins/home",
  // "./plugins/permission_handler",
  // "./plugins/alarm",
];

/// 需要buildRunner的模块
var buildRunnerModule = [
  "./",
  // "./plugins/dh_ability",
  // "./plugins/tree",
  // "./plugins/vbd",
  // "./plugins/favorite",
  // "./plugins/setting",
  // "./plugins/dh_gesture_pwd",
  // "./plugins/login",
  // "./plugins/home",
  // "./plugins/message_center",
  // "./plugins/alarm",
  // "./plugins/place"
  // "./plugins/alarm"
  // "./plugins/device_manager",
  // "./plugins/mine",
];

void main() async {
  var arr = Set();
  arr.addAll(buildRunnerModule);
  arr.addAll(autoNetModule);
  var future1 = runInDir(arr, getPubGetFuture, 'pubGet');

  // print(arr.length);
  var future2 =
      runInDir(autoNetModule, getAutoNetCvtFuture, "cvt2JsonRunner", future1);
  var future3 =
      runInDir(buildRunnerModule, getBuildRunnerFuture, "buildRunner", future2);
  runInDir(autoNetModule, getAutoNetGenFuture, "autoNetGen", future3);

  /*Future? f;

  buildRunnerModule.forEach((element) {
    if (f == null) {
      print("BuildRunner in $element");
      f = Process.start("flutter", ["pub", "run", "build_runner", "build"],
          workingDirectory: element, runInShell: true)
          .then((p) {
        stdout.addStream(p.stdout);
        return stderr.addStream(p.stderr);
      });
    } else {
      f!.whenComplete(() {
        print("BuildRunner in $element");
        f = Process.start("flutter", ["pub", "run", "build_runner", "build"],
            workingDirectory: element, runInShell: true)
            .then((p) {
          stdout.addStream(p.stdout);
          return stderr.addStream(p.stderr);
        });
      });
    }
  });*/
}

Future runInDir(Iterable arr, Future getFuture(String a), String tag,
    [Future? f]) {
  arr.forEach((element) {
    if (f == null) {
      print("$tag in $element");
      f = getFuture(element);
    } else {
      f = f!.whenComplete(() {
        print("$tag in $element");
        return getFuture(element);
      });
    }
  });
  return f!;
}

Future getPubGetFuture(String element) {
  return Process.start("flutter", ["pub", "get"],
          workingDirectory: element, runInShell: true)
      .then((p) {
    stdout.addStream(p.stdout);
    return stderr.addStream(p.stderr);
  });
}

Future getBuildRunnerFuture(String element) {
  return Process.start("flutter", ["pub", "run", "build_runner", "build"],
          workingDirectory: element, runInShell: true)
      .then((p) {
    stdout.addStream(p.stdout);
    return stderr.addStream(p.stderr);
  });
}

Future getAutoNetGenFuture(String element) {
  return Process.start("flutter", ["pub", "run", "auto_net:gen"],
          workingDirectory: element, runInShell: true)
      .then((p) {
    stdout.addStream(p.stdout);
    return stderr.addStream(p.stderr);
  });
}

Future getAutoNetCvtFuture(String element) {
  return Process.start("flutter", ["pub", "run", "auto_net:convert_2_json"],
          workingDirectory: element, runInShell: true)
      .then((p) {
    stdout.addStream(p.stdout);
    return stderr.addStream(p.stderr);
  });
}

/*autoNetModule.forEach((element) {
    print("AutoNet in $element");
    Process.start("dart", ["./plugins/auto_net/bin/gen.dart"],
            workingDirectory: element, runInShell: true)
        .then((p) {
      stdout.addStream(p.stdout);
      stderr.addStream(p.stderr);
    });
  });*/
