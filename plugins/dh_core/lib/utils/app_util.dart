import 'dart:io';

import 'dart:io' show Platform;
import 'package:device_info/device_info.dart';
import 'package:dh_core/debug/dh_log.dart';
import 'package:package_info/package_info.dart';


///手机相关信息
class AppUtil {
  static bool isAndroid() {
    return Platform.isAndroid;
  }

  /**
   * 安卓设备信息
   */
  static Future<AndroidDeviceInfo> getAndroidDeviceInfo() async {
    DeviceInfoPlugin deviceInfo = new DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    Log.it("AppUtil:",androidInfo.toString());
    return androidInfo;
  }



  /**
   *Ios设备信息
   */
  static Future<IosDeviceInfo> getIosDeviceInfo() async {
    DeviceInfoPlugin deviceInfo = new DeviceInfoPlugin();
    IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
    Log.it("AppUtil:",iosInfo.toString());

    return iosInfo;
  }


  static Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
    return <String, dynamic>{
      'version.securityPatch': build.version.securityPatch,
      'version.sdkInt': build.version.sdkInt,
      'version.release': build.version.release,
      'version.previewSdkInt': build.version.previewSdkInt,
      'version.incremental': build.version.incremental,
      'version.codename': build.version.codename,
      'version.baseOS': build.version.baseOS,
      'board': build.board,
      'bootloader': build.bootloader,
      'brand': build.brand,
      'device': build.device,
      'display': build.display,
      'fingerprint': build.fingerprint,
      'hardware': build.hardware,
      'host': build.host,
      'id': build.id,
      'manufacturer': build.manufacturer,
      'model': build.model,
      'product': build.product,
      'supported32BitAbis': build.supported32BitAbis,
      'supported64BitAbis': build.supported64BitAbis,
      'supportedAbis': build.supportedAbis,
      'tags': build.tags,
      'type': build.type,
      'isPhysicalDevice': build.isPhysicalDevice,
      'androidId': build.androidId,
      'systemFeatures': build.systemFeatures,
    };
  }

  Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo data) {
    return <String, dynamic>{
      'name': data.name,
      'systemName': data.systemName,
      'systemVersion': data.systemVersion,
      'model': data.model,
      'localizedModel': data.localizedModel,
      'identifierForVendor': data.identifierForVendor,
      'isPhysicalDevice': data.isPhysicalDevice,
      'utsname.sysname:': data.utsname.sysname,
      'utsname.nodename:': data.utsname.nodename,
      'utsname.release:': data.utsname.release,
      'utsname.version:': data.utsname.version,
      'utsname.machine:': data.utsname.machine,
    };
  }

  /**
   * 系统终端 terminalMode HUAWEI EML-AL00
   */
  static Future<String> getTerminalMode() async {
    if(isAndroid()){
      DeviceInfoPlugin deviceInfo = new DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      Log.it("AppUtil:",androidInfo.toString());
      String terminalMode = androidInfo.manufacturer +" "+androidInfo.model;
      Log.it("AppUtil: terminalMode:",terminalMode);
      return terminalMode;
    }else{
      IosDeviceInfo iosDeviceInfo = await getIosDeviceInfo();
      return iosDeviceInfo.model;
    }

  }

  /**
   * 系统版本号 terminalVersion ： "Android 9"
   */
  static Future<String> geterminalVersion() async {
    if(isAndroid()){
      DeviceInfoPlugin deviceInfo = new DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      String terminalVersion = "Android ${androidInfo.version.release}";
      Log.it("AppUtil: terminalVersion=",terminalVersion.toString());
      return terminalVersion;
    }else{
      IosDeviceInfo iosDeviceInfo = await getIosDeviceInfo();
      return "Ios ${iosDeviceInfo.systemVersion}";
    }

  }

  //获取APP版本号
  static Future<dynamic> getVersionString() async{
    PackageInfo  packageInfo = await PackageInfo.fromPlatform();
    Log.it("AppUtil: version=",packageInfo.version.toString());
    return packageInfo.version.toString();
  }

 /// 比较线上和本地版本号
  Future<bool> isNewVersionCompareTo(String? versionName) async{
    String? curVerName = await AppUtil.getVersionString();
    Log.it('versionName-->', versionName??'');
    Log.it('curVerName-->', curVerName??'');
    if((versionName !=null && versionName.isNotEmpty)
        && (curVerName != null && curVerName.isNotEmpty)) {
      List<String> splitLocalVers = curVerName.split('.');
      List<String> splitRemoteVers = versionName.split('.');
      while(splitLocalVers.length < 3) {
        splitLocalVers.add('0');
      }
      while(splitRemoteVers.length < 3) {
        splitRemoteVers.add('0');
      }
      if (versionName != curVerName) {
        int version1 = int.parse(splitRemoteVers[0]);
        int version2 = int.parse(splitRemoteVers[1]);
        int version3 = int.parse(splitRemoteVers[2]);
        int curVersion1 = int.parse(splitLocalVers[0]);
        int curVersion2 = int.parse(splitLocalVers[1]);
        int curVersion3 = int.parse(splitLocalVers[2]);
        if ((version1 > curVersion1)
            || (version1 == curVersion1 && version2 > curVersion2)
            || (version1 == curVersion1 && version2 == curVersion2 && version3 > curVersion3)) {
          return true;
        }
      }
    }
    return false;
  }

}
