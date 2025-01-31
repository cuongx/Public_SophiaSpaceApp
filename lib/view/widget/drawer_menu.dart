import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sophia_hub/constant/sophia_hub_app.dart';
import 'package:sophia_hub/helper/show_flush_bar.dart';
import 'package:sophia_hub/view/page/account/account_page.dart';
import 'package:sophia_hub/view_model/share_pref.dart';
import 'package:url_launcher/url_launcher.dart';

class DrawerMenu extends StatefulWidget {
  @override
  _DrawerMenuState createState() => _DrawerMenuState();
}

class _DrawerMenuState extends State<DrawerMenu>
    with SingleTickerProviderStateMixin {
  Color endValue = Colors.black.withOpacity(0.8);
  Color beginColor = Colors.white;
  late AnimationController controller;
  late Animation<Color?> animation;

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(duration: Duration(milliseconds: 400), vsync: this);
    animation =
        ColorTween(begin: beginColor, end: endValue).animate(controller);
  }


  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: AnimatedBuilder(
          builder: (BuildContext context, Widget? child) {
            return Container(
              color: animation.value,
              child: child,
            );
          },
          animation: animation,
          child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Provider.of<SharedPref>(context,listen: false).materialColor.shade900,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          offset: Offset(0.0, 1.0), //(x,y)
                          blurRadius: 6.0,
                        ),
                      ],
                    ),
                    height: 150,
                    width: 150,
                    child: Image(
                      fit: BoxFit.fill,
                  image: AssetImage('media/logo/astronaut_logo_no_bkg.png'),
                ),
                  ),
                  ListTile(
                      title: Text("Sophia Space",style:Theme.of(context).textTheme.headline5,textAlign: TextAlign.center,),
                    subtitle: Text("Khám phá vũ trụ trong bạn",textAlign: TextAlign.center,),
                  ),
                  SizedBox(height: 30,),
                  Card(
                  child: ListTile(
                    onTap: (){
                      Navigator.of(context).pushNamed(AccountPage.nameRoute);
                    },
                      leading: Icon(Icons.person), title: Text("Tài khoản"))),
                  Card(
                      child: ListTile(
                        onTap: ()async{
                          if (!await launch(SophiaSpaceLink.feedBackForm)) {
                            showErrMessage(context, Exception("Không mở được đường dẫn"));
                          };
                        },
                          leading: Icon(Icons.message_rounded), title: Text("Báo lỗi"))),
                  Card(
                      child: ListTile(
                        onTap: ()async{
                          Share.share('Ứng dụng "Nhật ký thói quen: Sophia Space" ${SophiaSpaceLink.playStore}');
                        },
                          leading: Icon(Icons.share), title: Text("Chia sẻ"))),
                  Card(
                      child: ListTile(
                        onTap: ()async{
                          if (!await launch(SophiaSpaceLink.playStore)) {
                            showErrMessage(context, Exception("Không mở được đường dẫn"));
                          };
                        },
                          leading: Icon(Icons.star_rate_rounded), title: Text("Đánh giá ứng dụng"))),
                  Spacer(flex: 9,),
                  Text(''),
                  FutureBuilder<PackageInfo>(
                    initialData: null,
                    future: PackageInfo.fromPlatform(),
                      builder: (context,snapshot){
                    if(snapshot.data == null) return Text('___');
                    else return Text("Phiên bản ${snapshot.data?.version ?? 'NaN  '}");
                  }),
                  Spacer(flex: 1,),
                ],
              )),
        ),
      ),
    );
  }
}
