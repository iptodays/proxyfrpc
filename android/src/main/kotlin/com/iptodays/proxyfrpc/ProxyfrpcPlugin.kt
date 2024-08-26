package com.iptodays.proxyfrpc

import frpclib.Frpclib
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import kotlin.concurrent.thread

/** ProxyfrpcPlugin */
class ProxyfrpcPlugin: FlutterPlugin, MethodCallHandler {
  private lateinit var channel : MethodChannel

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "proxyfrpc")
    channel.setMethodCallHandler(this)
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    when (call.method) {
      "startFRPC" -> {
        startFRPC(call.argument<String>("uid")!!, call.argument("cfgFilePath")!!)
        result.success(null)
      }
      "stopFRPC" -> {
        stopFRPC(call.argument<String>("uid")!!)
        result.success(null)
      }
      "isRunning" -> {
        result.success(isRunning(call.argument<String>("uid")!!))
      }
      else -> {
        result.notImplemented()
      }
    }
  }

  /// 启动内网穿透
  private fun startFRPC(uid: String, cfgFilePath: String) {
    if (isRunning(uid)) {
      return
    }
    thread {
      Frpclib.start(uid, cfgFilePath)
    }
  }

  /// 关闭内网穿透
  private fun stopFRPC(uid: String) {
    if (isRunning(uid)) {
      Frpclib.stop(uid)
    }
  }

  /// 查询uid是否正在运行
  private fun isRunning(uid :String):Boolean {
    return Frpclib.isRunning(uid)
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }
}
