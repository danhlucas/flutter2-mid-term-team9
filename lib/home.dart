import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/services.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_social_content_share/flutter_social_content_share.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isLogin = false;
  Map _user = {};

  Future<void> initPlatformState() async {
    String platformVersion;
    //Platform messages may fail, so we use a try/catch PlatformException.
    try {
      // khai báo mảng bất đồng bộ.
      platformVersion = (await FlutterSocialContentShare.platformVersion)!;
      // If the widget was removed from the tree while the asynchronous platform
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      FacebookAuth.instance.webInitialize(
        appId: "938054740234939",
        cookie: true,
        xfbml: true,
        version: "v12.0",
      );
    }
    initPlatformState();
    return Scaffold(
      body: Center(
        child: Container(
          child: _isLogin
              ? Column(
                  children: [
                    SizedBox(
                      height: 150,
                    ),
                    Image.network(
                      _user["picture"]["data"]["url"],
                      //lấy hình ảnh và dư liệu trên fb
                      fit: BoxFit.cover,
                      height: 100,
                      width: 100,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      _user["name"],
                      //lấy tên trên fb
                      style: TextStyle(
                          fontSize: 20,
                          color: Color(0xFF8C746A),
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    //log out
                    Container(
                      // color: Colors.red,
                      child: ElevatedButton(
                        onPressed: () async {
                          await FacebookAuth.instance.logOut().then((value) {
                            setState(() {
                              _isLogin = false;
                            });
                          });
                        },
                        child: Text("Log out", style: TextStyle(fontSize: 16)),
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    //share
                    ElevatedButton(
                        onPressed: () async {
                          await FlutterSocialContentShare.share(
                              type: ShareType.facebookWithoutImage,
                              url:
                                  "https://github.com/danhlucas/flutter2-mid-term-team9.git/",
                              quote: "Github Team9");
                        },
                        child: Text("Share to Facebook",
                            style: TextStyle(fontSize: 16))),
                  ],
                ) //login
              : SizedBox(
                  width: 150,
                  height: 100,
                  child: ElevatedButton(
                    onPressed: () async {
                      final LoginResult result =
                          await FacebookAuth.instance.login(
                        permissions: ['public_profile', 'email'],
                      );
                      if (result.status == LoginStatus.success) {
                        final requestData = await FacebookAuth.instance
                            .getUserData(fields: "name, picture");
                        SizedBox(
                          height: 50,
                        );

                        setState(() {
                          _user = requestData;
                          _isLogin = true;
                        });
                        print(_user);
                      } else {
                        print(result.status);
                        print(result.message);
                      }
                    },
                    child: Text(
                      'Login',
                      style: TextStyle(fontSize: 28),
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
