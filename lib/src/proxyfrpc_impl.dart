/*
 * @Author: iptoday wangdong1221@outlook.com
 * @Date: 2023-02-09 17:39:03
 * @LastEditors: iptoday wangdong1221@outlook.com
 * @LastEditTime: 2024-08-26 12:56:54
 * @FilePath: /proxyfrpc/lib/src/proxyfrpc_impl.dart
 * 
 * Copyright (c) 2023 by ${git_name_email}, All Rights Reserved.
 */
import 'dart:async';
import 'dart:io';

import 'package:socks5_proxy/socks.dart';
import 'proxyfrpc_platform_interface.dart';

class Proxyfrpc {
  static Proxyfrpc get instance => Proxyfrpc._instanceFor();
  static Proxyfrpc? _instance;
  factory Proxyfrpc._instanceFor() => _instance ??= Proxyfrpc._();
  Proxyfrpc._();

  StreamSubscription<Connection>? _subscription;
  SocksServer? _server;

  /// 启动socks5服务
  /// Start socks5 server
  Future<void> startSocks5({
    required Map<int, InternetAddress?> portAddr,
    bool allowIPv6 = false,
    bool Function(String username, String password)? authHandler,
    void Function(Connection connection)? listen,
  }) async {
    if (_server == null) {
      _server = SocksServer(authHandler: authHandler);
      _subscription = _server!.connections.listen(
        (connection) async {
          if (listen != null) {
            listen(connection);
          }
          await connection.forward(allowIPv6: allowIPv6);
        },
      );
    }
    for (var port in portAddr.keys) {
      if (!_server!.proxies.containsKey(port)) {
        unawaited(
          _server!.bind(portAddr[port] ?? InternetAddress.anyIPv4, port),
        );
      }
    }
  }

  /// 关闭socks5服务
  /// Stop socks5 server
  Future<void> stopSocks5([int? port]) async {
    if (_server == null) return;
    if (port == null) {
      for (var element in _server!.proxies.values) {
        element.close();
      }
      _server!.proxies.clear();
    } else {
      _server?.proxies[port]?.close();
      _server?.proxies.remove(port);
    }
    if (_server!.proxies.isEmpty) {
      _subscription?.cancel();
    }
  }

  /// 启动FRPC服务
  /// Start FRPC service
  Future<void> startFRPC({
    required String uid,
    required String cfgFilePath,
  }) async {
    return ProxyfrpcPlatform.instance.startFRPC(
      uid: uid,
      cfgFilePath: cfgFilePath,
    );
  }

  /// 关闭FRPC服务
  /// Stop FRPC service
  Future<void> stopFRPC({required String uid}) async {
    return ProxyfrpcPlatform.instance.stopFRPC(
      uid: uid,
    );
  }
}
