import Flutter
import UIKit
import Frpclib

public class ProxyfrpcPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "proxyfrpc", binaryMessenger: registrar.messenger())
    let instance = ProxyfrpcPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
      switch call.method {
          case "startFRPC":
              let args = call.arguments as! Dictionary<String, String>
              startFRPC(uid: args["uid"]!,
                        cfgFilePath: args["cfgFilePath"]!)
              result(nil)
              break
          case "stopFRPC":
              let args = call.arguments as! Dictionary<String, String>
              stopFRPC(uid: args["uid"]!)
              result(nil)
              break
          case "isRunning":
              let args = call.arguments as! Dictionary<String, String>
              result(isRunnning(uid: args["uid"]!))
          default:
              result(FlutterMethodNotImplemented)
      }
  }
    
    private func startFRPC(uid: String, cfgFilePath: String) {
        if !isRunnning(uid: uid) {
            Frpclib.FrpclibStart(uid, cfgFilePath)
        }
    }
    
    private func stopFRPC(uid: String) {
        if isRunnning(uid: uid) {
            Frpclib.FrpclibStop(uid)
        }
    }
    
    private func isRunnning(uid: String)->Bool {
        return Frpclib.FrpclibIsRunning(uid)
    }
}
