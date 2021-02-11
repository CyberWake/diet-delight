import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../Models/foodItemModel.dart';
import '../../konstants.dart';

class FavouritesPage extends StatefulWidget {
  @override
  _FavouritesPageState createState() => _FavouritesPageState();
}

class _FavouritesPageState extends State<FavouritesPage> {
  Widget item(FoodItemModel foodItem) {
    return InkWell(
      onTap: () {},
      child: Container(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 22.0),
          child: Row(
            children: [
              Expanded(
                flex: 8,
                child: Padding(
                  padding: const EdgeInsets.only(left: 45.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 10,
                        width: 10,
                        child: Image.asset(
                          foodItem.isVeg
                              ? 'images/veg.png'
                              : 'images/nonVeg.png',
                          fit: BoxFit.fitHeight,
                          scale: 0.5,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        foodItem.foodName,
                        style: appBarTextStyle.copyWith(
                            fontSize: 14, fontWeight: FontWeight.w400),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        foodItem.des,
                        style: appBarTextStyle.copyWith(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Color.fromRGBO(144, 144, 144, 1)),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Container(
                        alignment: Alignment.bottomRight,
                        padding: EdgeInsets.only(right: 10),
                        child: IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.favorite_border,
                              size: 13,
                            )),
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Container(
                  margin: EdgeInsets.only(right: 20),
                  decoration: authFieldDecoration,
                  child: CachedNetworkImage(
                    imageUrl: foodItem.picture ??
                        "http://via.placeholder.com/350x150",
                    imageBuilder: (context, imageProvider) => Container(
                      height: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => FlutterLogo(
                      size: 60,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  FoodItemModel dummyModel = new FoodItemModel();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dummyModel.isVeg = false;
    dummyModel.foodName = "Vada-Pav";
    dummyModel.des = "Made with amazing veg flavours";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 18.0),
            child: item(dummyModel),
          )
        ],
      ),
    );
  }
}
