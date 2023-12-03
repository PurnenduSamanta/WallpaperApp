import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_wallpaper_manager/flutter_wallpaper_manager.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class FullScreen extends StatefulWidget {
  final String screenImageUrl;
  const FullScreen({super.key, required this.screenImageUrl});

  @override
  State<FullScreen> createState() => _FullScreenState();
}

class _FullScreenState extends State<FullScreen> {

  String _platformVersion = 'Unknown';
  String __heightWidth = "Unknown";

  @override
  void initState() {
    super.initState();
    initAppState();
  }

  Future<void>setWallpaper() async
  {
    try {
      int location = WallpaperManager.HOME_SCREEN;
      var file = await DefaultCacheManager().getSingleFile(widget.screenImageUrl);
      await WallpaperManager.setWallpaperFromFile(file.path, location);
    } on PlatformException {}

  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initAppState() async {
    String platformVersion;
    String _heightWidth;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion = await WallpaperManager.platformVersion ?? 'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    try {
      int height = await WallpaperManager.getDesiredMinimumHeight();
      int width = await WallpaperManager.getDesiredMinimumWidth();
      _heightWidth =
          "Width = " + width.toString() + " Height = " + height.toString();
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
      _heightWidth = "Failed to get Height and Width";
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      __heightWidth = _heightWidth;
      _platformVersion = platformVersion;
    });
  }



  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Container(
        child: Column(
          children: [
            Expanded(child: Image.network(widget.screenImageUrl)),
            InkWell(
              onTap: (){
                setWallpaper();
              },
              child: Container(
                width: double.infinity,
                height: 60,
                color: Colors.black,
                child: const Center(
                  child: Text(
                    "Set Wallpaper",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
