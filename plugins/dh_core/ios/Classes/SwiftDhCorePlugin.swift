import Flutter
import UIKit

public class SwiftDhCorePlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "dh_core", binaryMessenger: registrar.messenger())
    let instance = SwiftDhCorePlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    //result("iOS " + UIDevice.current.systemVersion)
    if "getProxyHost" == call.method {
        let proxySettings = CFNetworkCopySystemProxySettings()
        let dictProxy = proxySettings as? [AnyHashable : Any]
        //是否开启了http代理
        if (dictProxy?["HTTPEnable"] as? NSNumber)?.boolValue ?? false {
            let proxyHost = dictProxy?["HTTPProxy"] as? String
            result(proxyHost)
        } else {
            result(nil)
        }
    } else if "getProxyPort" == call.method {
        let proxySettings = CFNetworkCopySystemProxySettings()
        let dictProxy = proxySettings as? [AnyHashable : Any]
        //是否开启了http代理
        if (dictProxy?["HTTPEnable"] as? NSNumber)?.boolValue ?? false {
            let proxyPort = String(format: "%ld", (dictProxy?["HTTPPort"] as? NSNumber)?.intValue ?? 0)
            result(proxyPort)
        } else {
            result(nil)
        }
    } else {
        result(FlutterMethodNotImplemented)
    }
  }
}

