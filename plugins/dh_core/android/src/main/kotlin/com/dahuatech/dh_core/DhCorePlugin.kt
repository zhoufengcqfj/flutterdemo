package com.dahuatech.dh_core


import androidx.annotation.NonNull

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar
import android.os.Environment


/** DhCorePlugin */
class DhCorePlugin : FlutterPlugin, MethodCallHandler {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "dh_core")
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        when (call.method) {
            "getPlatformVersion" ->
                result.success("Android ${android.os.Build.VERSION.RELEASE}");
            "getExternalStorageDirectory" ->
                result.success(Environment.getExternalStorageDirectory().toString());
            "getExternalStoragePublicDirectory" -> {
                val type = call.argument<String>("type")
                result.success(Environment.getExternalStoragePublicDirectory(type).toString());
            }
            "getProxyHost" ->
                result.success(getProxyHost());
            "getProxyPort" ->
                result.success(getProxyPort());
            else -> result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    private fun getProxyHost(): String? {
        return System.getProperty("http.proxyHost")
    }

    private fun getProxyPort(): String? {
        return System.getProperty("http.proxyPort")
    }
}
