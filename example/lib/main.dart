// ignore_for_file: avoid_print

/*
 * @Author: iptoday wangdong1221@outlook.com
 * @Date: 2023-02-09 17:39:03
 * @LastEditors: iptoday wangdong1221@outlook.com
 * @LastEditTime: 2024-08-26 12:57:34
 * @FilePath: /proxyfrpc/example/lib/main.dart
 * 
 * Copyright (c) 2023 by ${git_name_email}, All Rights Reserved.
 */
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';

import 'package:proxyfrpc/proxyfrpc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {}

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(),
            MaterialButton(
              color: Colors.blueGrey,
              child: const Text(
                'Start Socks5',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                print('启动Socks5');
                Proxyfrpc.instance.startSocks5(
                  portAddr: {6000: null},
                  listen: (connection) {
                    print(
                      '${connection.address.address}:${connection.port} ==> ${connection.desiredAddress.address}:${connection.desiredPort}',
                    );
                  },
                );
              },
            ),
            MaterialButton(
              color: Colors.blueGrey,
              child: const Text(
                'Stop Socks5',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                print('关闭Socks5');
                Proxyfrpc.instance.stopSocks5();
              },
            ),
            MaterialButton(
              color: Colors.blueGrey,
              child: const Text(
                'Start frpc',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onPressed: () async {
                String cfg = '''
[common]
server_addr = xxx.xxx.xx.xx
server_port = xxxx
token = xxxxxxxx
login_fail_exit = false

[Proxyfrpc_tcp]
type = tcp
local_ip = 127.0.0.1
local_port = xxxx
remote_port = xxxx

[Proxyfrpc_stcp]
type = stcp
local_ip = 127.0.0.1
local_port = xxxx
sk = 12345678

[Proxyfrpc_stcp_visitor]
type = stcp
role = visitor
server_name = xxx
sk = abcdefg
bind_addr = 127.0.0.1
bind_port = 6000
''';
                Directory supportDir = await getApplicationSupportDirectory();
                File file = File('${supportDir.path}/frpc.ini');
                if (file.existsSync()) {
                  file.deleteSync(recursive: true);
                }
                file.createSync(recursive: true);
                file.writeAsStringSync(cfg);
                Proxyfrpc.instance.startFRPC(
                  uid: 'test1',
                  cfgFilePath: file.path,
                );
              },
            ),
            MaterialButton(
              color: Colors.blueGrey,
              child: const Text(
                'Stop frpc',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                Proxyfrpc.instance.stopFRPC(uid: 'test1');
              },
            ),
          ],
        ),
      ),
    );
  }
}
