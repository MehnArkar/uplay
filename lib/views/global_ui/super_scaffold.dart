import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../utils/constants/app_constant.dart';

final RouteObserver<PageRoute> routeObserver =  RouteObserver<PageRoute>();

class SuperScaffold extends StatefulWidget{
  final Widget child;
  final Color topColor;
  final Color botColor;
  final Color backgroundColor;
  final AppBar? appBar;
  final bool isTopSafe;
  final bool isBotSafe;
  final bool isResizeToAvoidBottomInset;
  final FloatingActionButton? floatingActionButton;
  final Brightness statusBarBrightness;
  final Brightness statusIconBrightness;
  final VoidCallback? onWillPop;
  final bool isWillPop;
  const SuperScaffold({Key? key,required this.child,this.floatingActionButton, this.topColor = Colors.white,this.botColor = Colors.white,this.backgroundColor=Colors.white,this.appBar,this.isBotSafe=true,this.isTopSafe=true,this.isResizeToAvoidBottomInset=true, this.statusBarBrightness = Brightness.light,this.statusIconBrightness=Brightness.dark,this.onWillPop,this.isWillPop=true}) : super(key: key);

  @override
  State<SuperScaffold> createState() => _SuperScaffoldState();
}

class _SuperScaffoldState extends State<SuperScaffold> with RouteAware {

  @override
  void initState() {
    setStatusAndNavigationBarColor();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
  }

  @override
  void didPopNext() {
    setStatusAndNavigationBarColor();
    super.didPopNext();
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }






  @override
  Widget build(BuildContext context) {
    setStatusAndNavigationBarColor();
    return GestureDetector(
      onTap: (){
        FocusManager.instance.primaryFocus!.unfocus();
      },
      child: WillPopScope(
        onWillPop: ()async{
          if(widget.onWillPop != null){
            widget.onWillPop!();
          }
          return widget.isWillPop;
        },
        child: Scaffold(
          appBar: widget.appBar,
          backgroundColor: widget.backgroundColor,
          floatingActionButton: widget.floatingActionButton,
          resizeToAvoidBottomInset:widget.isResizeToAvoidBottomInset,
          body: MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: AppConstants.textScaleFactor),
            child: Column(
              children: [
                if(widget.isTopSafe)
                  topPadding(widget.topColor),
                Expanded(child: widget.child),
                if(widget.isBotSafe)
                  botPadding(widget.botColor),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget topPadding(Color color){
    return Container(
      width: double.maxFinite,
      height: MediaQuery.of(Get.context!).padding.top,
      color: color,
    );
  }

  Widget botPadding(Color color){
    return Container(
      width:double.maxFinite,
      height: MediaQuery.of(Get.context!).padding.bottom,
      color: color,
    );
  }

  void setStatusAndNavigationBarColor(){
    //Set status bar color and brightness
    if(widget.isTopSafe){
      setStatusBarColor();
    }
    //Set navigation bar color and brightness
    if(widget.isBotSafe) {
      setNavigationBarColor();
    }
  }

  void setStatusBarColor(){
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarColor: widget.topColor,
          statusBarBrightness: widget.topColor.computeLuminance() > 0.5? Brightness.dark:Brightness.light,
          statusBarIconBrightness: widget.topColor.computeLuminance() > 0.5? Brightness.dark:Brightness.light,
        ));
  }



  void setNavigationBarColor(){
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
            systemNavigationBarIconBrightness:widget.botColor.computeLuminance() > 0.5? Brightness.dark:Brightness.light,
            systemNavigationBarColor: widget.botColor));
  }
}






