import 'dart:io';

import 'package:dh_core/dh_core.dart';

class DhHttpOverrides extends HttpOverrides {
  static Future<DhHttpOverrides> createHttpProxy() async {
    return DhHttpOverrides._(
        await DhCore.getProxyHost(), await DhCore.getProxyPort());
  }

  final String? host;
  final String? port;

  DhHttpOverrides._(this.host, this.port);

  @override
  HttpClient createHttpClient(SecurityContext? context) {
    HttpClient client = super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) {
        return true;
      }
      ..findProxy = _findProxy;
    return client;
  }

  String _findProxy(uri) {
    Map<String, String>? environment;
    if (host != null && host != "") {
      environment = {};
      if (port != null && port != "" && port != "0") {
        environment['http_proxy'] = '$host:$port';
        environment['https_proxy'] = '$host:$port';
      } else {
        environment['http_proxy'] = '$host:8888';
        environment['https_proxy'] = '$host:8888';
      }
    }
    return HttpClient.findProxyFromEnvironment(uri, environment: environment);
  }
}
