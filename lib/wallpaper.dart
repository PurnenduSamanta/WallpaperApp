import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pixel_wallpaper/fullScreen.dart';



class Wallpaper extends StatefulWidget {

  @override
  State<Wallpaper> createState() => _WallpaperState();
}

class _WallpaperState extends State<Wallpaper> {

  List images=[];
  int pageNo =1;
  @override
  void initState() {
    fetchapi();
    super.initState();
  }

  fetchapi() async {
    await http.get(Uri.parse('https://api.pexels.com/v1/curated?per_page=80'),
        headers: {
          'Authorization':
          'QeCOcPVzF78W9dpDeUJjjF4pOqI1q3HQ6RIbGyCIyh8EFbD1gDUV1KWc'
        }).then((value) {
          Map result= jsonDecode(value.body);
          setState(() {
            images=result['photos'];
          });
          print("joy $images");
    });
  }

  loadMoreImages() async
  {

    setState(() {
      pageNo=pageNo+1;
    });
    String url= 'https://api.pexels.com/v1/curated?per_page=80&page=$pageNo';
    await http.get(Uri.parse(url),
        headers: {
          'Authorization':
          'QeCOcPVzF78W9dpDeUJjjF4pOqI1q3HQ6RIbGyCIyh8EFbD1gDUV1KWc'
        }).then((value) {
      Map result= jsonDecode(value.body);
      setState(() {
       images.addAll(result['photos']);
      });
    });


  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
              child: GridView.builder(
                  itemCount: images.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 2,
                      childAspectRatio: 2 / 3,
                      mainAxisSpacing: 2),
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>FullScreen(screenImageUrl: images[index]['src']['large2x'])));
                      },
                      child: Image.network(
                        images[index]['src']['tiny'],
                        fit: BoxFit.cover,
                      ),
                    );
                  })),
          InkWell(
            onTap: (){
              loadMoreImages();
            },
            child: Container(
              width: double.infinity,
              height: 60,
              color: Colors.black,
              child: const Center(
                child: Text(
                  "Load More",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
