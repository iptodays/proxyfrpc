/*
 * @Author: iptoday wangdong1221@outlook.com
 * @Date: 2023-02-09 17:39:03
 * @LastEditors: iptoday wangdong1221@outlook.com
 * @LastEditTime: 2023-02-09 20:34:16
 * @FilePath: /proxyfrpc/lib/proxyfrpc_method_channel.dart
 * 
 * Copyright (c) 2023 by ${git_name_email}, All Rights Reserved.
 */
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'proxyfrpc_platform_interface.dart';

/// An implementation of [ProxyfrpcPlatform] that uses method channels.
class MethodChannelProxyfrpc extends ProxyfrpcPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('proxyfrpc');

  @override
  Future<void> startFRPC({
    required String uid,
    required String cfgFilePath,
  }) async {
    return methodChannel.invokeMethod(
      'startFRPC',
      {'uid': uid, 'cfgFilePath': cfgFilePath},
    );
  }

  @override
  Future<void> stopFRPC({required String uid}) async {
    return methodChannel.invokeMethod(
      'stopFRPC',
      {
        'uid': uid,
      },
    );
  }
}
