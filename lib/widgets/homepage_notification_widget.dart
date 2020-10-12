import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class HomeNotificationWidget extends StatefulWidget {
  String st, dst;

  HomeNotificationWidget({this.st, this.dst});

  @override
  _HomeNotificationWidgetState createState() => _HomeNotificationWidgetState();
}

class _HomeNotificationWidgetState extends State<HomeNotificationWidget> {
  final databaseReference = Firestore.instance;
  List items = [];

  fetchPoster() async {
    await databaseReference
        .collection(widget.st)
        .document('posters')
        .get()
        .then((snapshot) {
      setState(() {
        items = snapshot.data["posterList"] ?? [];
      });
//      print(snapshot.data["posterList"]);
//      print(items);
    });
  }

  @override
  void initState() {
    super.initState();
    fetchPoster();
  }

  @override
  Widget build(BuildContext context) {
    return items.isEmpty
        ? Container()
        : AspectRatio(
            aspectRatio: 2 / 1,
            child: Swiper(
              loop: true,
              itemCount: items.length,
              scrollDirection: Axis.horizontal,
              viewportFraction: 0.65,
              autoplay: true,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  margin: EdgeInsets.only(bottom: 15, top: 10),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                    color: Colors.grey.shade200,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: Image.network(
                        items[index],
                        fit: BoxFit.fill,
                      ),
                    ),
//            child: Text(items[index]),
                  ),
                );
              },
              scale: .5,
              pagination: SwiperPagination(
                margin: EdgeInsets.only(top: 100),
                alignment: Alignment.bottomCenter,
                builder: RectSwiperPaginationBuilder(
//          space: 2,
                  color: Colors.grey,
                  activeColor: Colors.teal.shade700,
                  activeSize: Size(15, 15),
                  size: Size(13, 13),
                ),
//        DotSwiperPaginationBuilder(
//          color: Colors.grey,
//        ),
              ),
            ),
          );
  }
}
