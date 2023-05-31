import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;



class Wallpaper extends StatefulWidget {

  @override
  State<Wallpaper> createState() => _WallpaperState();
}

class _WallpaperState extends State<Wallpaper> {

  List images=[];
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
              child: Container(
            child: GridView.builder(
                itemCount: 80,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 2,
                    childAspectRatio: 2 / 3,
                    mainAxisSpacing: 2),
                itemBuilder: (context, index) {
                  return Container(color: Colors.white);
                }),
          )),
          Container(
            width: double.infinity,
            height: 60,
            color: Colors.black,
            child: const Center(
              child: Text(
                "Load More",
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }
}
