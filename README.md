# proxyfrpc

基于[frp](https://github.com/fatedier/frp)实现的内网穿透socks代理.
Intranet penetration socks proxy based on [frp](https://github.com/fatedier/frp).

``` socks5
// 启动socks5
// Start socks5
Proxyfrpc.instance.startSocks5(portAddr: {6000: null});

// 关闭socks5
// Stop socks5
Proxyfrpc.instance.stopSocks5();
```

``` frpc
// 启动frpc
// Start frpc
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
''';
Directory supportDir = await getApplicationSupportDirectory();
File file = File('${supportDir.path}/frpc.ini');
file.createSync(recursive: true);
file.writeAsStringSync(cfg);
Proxyfrpc.instance.startFRPC( uid: 'test1', cfgFilePath: file.path);

// 关闭frpc
// Stop frpc
Proxyfrpc.instance.stopFRPC(uid: 'test1');
```