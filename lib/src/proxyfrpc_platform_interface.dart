/*
 * @Author: iptoday wangdong1221@outlook.com
 * @Date: 2023-02-09 17:39:03
 * @LastEditors: iptoday wangdong1221@outlook.com
 * @LastEditTime: 2023-02-09 20:34:22
 * @FilePath: /proxyfrpc/lib/proxyfrpc_platform_interface.dart
 * 
 * Copyright (c) 2023 by ${git_name_email}, All Rights Reserved.
 */
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'proxyfrpc_method_channel.dart';

abstract class ProxyfrpcPlatform extends PlatformInterface {
  /// Constructs a ProxyfrpcPlatform.
  ProxyfrpcPlatform() : super(token: _token);

  static final Object _token = Object();

  static ProxyfrpcPlatform _instance = MethodChannelProxyfrpc();

  /// The default instance of [ProxyfrpcPlatform] to use.
  ///
  /// Defaults to [MethodChannelProxyfrpc].
  static ProxyfrpcPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [ProxyfrpcPlatform] when
  /// they register themselves.
  static set instance(ProxyfrpcPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<void> startFRPC({
    required String uid,
    required String cfgFilePath,
  }) async {
    throw UnimplementedError('startFRPC() has not been implemented.');
  }

  Future<void> stopFRPC({required String uid}) async {
    throw UnimplementedError('stopFRPC() has not been implemented.');
  }
}
