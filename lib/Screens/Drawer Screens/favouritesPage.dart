import 'package:cached_network_image/cached_network_image.dart';
import 'package:diet_delight/Models/addFavouritesModel.dart';
import 'package:diet_delight/services/apiCalls.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../Models/foodItemModel.dart';
import '../../konstants.dart';

class FavouritesPage extends StatefulWidget {
  @override
  _FavouritesPageState createState() => _FavouritesPageState();
}

class _FavouritesPageState extends State<FavouritesPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<List> favourites = Api.favourites;
  List<int> favPressed = List();
  final _apiCall = Api.instance;
  ScrollController _scrollController = new ScrollController();
  bool isLoaded = false;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    await getData();
    print(favourites[0]);
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    setState(() {});
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  Widget item(FoodItemModel foodItem, AddFavouritesModel details) {
    return Material(
      borderRadius: BorderRadius.circular(15.0),
      elevation: 0,
      color: Colors.transparent,
      child: Container(
        margin: EdgeInsets.symmetric(
            vertical: 10, horizontal: MediaQuery.of(context).size.width * 0.05),
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            color: questionnaireDisabled.withOpacity(0.4)),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 0.0),
          child: Row(
            children: [
              Expanded(
                flex: 8,
                child: Container(
                  height: MediaQuery.of(context).size.width * 0.275,
                  child: Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.width * 0.0375,
                        left: 15.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 15,
                          width: 15,
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
                              fontSize: 13, fontWeight: FontWeight.w400),
                        ),
                        foodItem.featured == 1
                            ? Padding(
                                padding: EdgeInsets.only(left: 5.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    ImageIcon(
                                        AssetImage('images/featured_icon.png'),
                                        color: featuredColor,
                                        size: 12),
                                    Text(
                                      'Featured',
                                      style: appBarTextStyle.copyWith(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600,
                                          color: featuredColor),
                                    ),
                                  ],
                                ),
                              )
                            : SizedBox(),
//                       SizedBox(
//                         height: 10,
//                       ),
// //                      Text(
// //                        foodItem.des,
// //                        style: appBarTextStyle.copyWith(
// //                            fontSize: 12,
// //                            fontWeight: FontWeight.w400,
// //                            color: Color.fromRGBO(144, 144, 144, 1)),
// //                      ),
//                       SizedBox(
//                         height: 4,
//                       ),
                        Spacer(),
                        Container(
                          alignment: Alignment.bottomRight,
                          padding: EdgeInsets.only(right: 10),
                          child: IconButton(
                              onPressed: () async {
                                await _apiCall.deleteFavourites(details);
                                setState(() {
                                  getData();
                                });
                              },
                              icon: Icon(Icons.favorite,
                                  size: 16, color: defaultPurple)),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Container(
                  margin: EdgeInsets.only(right: 15),
                  child: Material(
                    elevation: 2,
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    child: CachedNetworkImage(
                      imageUrl: foodItem.picture ??
                          "http://via.placeholder.com/350x150",
                      imageBuilder: (context, imageProvider) => Container(
                        height: MediaQuery.of(context).size.width * 0.2,
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      placeholder: (context, url) => SpinKitChasingDots(
                        color: defaultPurple,
                        size: 32,
                      ),
                      errorWidget: (context, url, error) => FlutterLogo(
                        size: 60,
                      ),
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

  Future getData() async {
    setState(() {
      isLoaded = false;
    });
    favourites = await _apiCall.getFavourites();
    List fav = favourites[1];
    favourites[1].sort((a, b) {
      return a.menuItem.foodName
          .toString()
          .compareTo(b.menuItem.foodName.toString());
    });
    print('fav: $fav');
    if (mounted) {
      setState(() {
        isLoaded = true;
      });
    }
  }

//
//  FoodItemModel dummyModel = new FoodItemModel();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData().whenComplete(() {
      if (mounted) {
        setState(() {
          isLoaded = true;
        });
      }
    });
    print(favourites);
//    dummyModel.isVeg = false;
//    dummyModel.foodName = "Vada-Pav";
//    dummyModel.des = "Made with amazing veg flavours";
  }

  @override
  Widget build(BuildContext context) {
    favourites = Api.favourites;
    return SafeArea(
      child: Container(
          child: isLoaded == false
              ? Center(
                  child: SpinKitThreeBounce(
                  color: defaultPurple,
                  size: 32,
                ))
              : Scaffold(
                  key: _scaffoldKey,
                  backgroundColor: Colors.transparent,
                  body: Container(
                      child: Padding(
                    padding: const EdgeInsets.only(top: 15.0),
                    child: SmartRefresher(
                      enablePullDown: true,
                      enablePullUp: false,
                      header: WaterDropHeader(),
                      footer: CustomFooter(
                        builder: (BuildContext context, LoadStatus mode) {
                          Widget body;
                          if (mode == LoadStatus.idle) {
                            body = Text("pull up load");
                          } else if (mode == LoadStatus.loading) {
                            body = CupertinoActivityIndicator();
                          } else if (mode == LoadStatus.failed) {
                            body = Text("Load Failed!Click retry!");
                          } else if (mode == LoadStatus.canLoading) {
                            body = Text("release to load more");
                          } else {
                            body = Text("No more Data");
                          }
                          return Container(
                            height: 55.0,
                            child: Center(child: body),
                          );
                        },
                      ),
                      controller: _refreshController,
                      onRefresh: _onRefresh,
                      child: favourites[1].length == 0
                          ? Center(
                              child: Text(
                                  'No dishes have been added as favourite yet',
                                  style: nullSafetyStyle),
                            )
                          : ListView.builder(
                              controller: _scrollController,
                              itemCount: favourites[1].length,
                              itemBuilder: (BuildContext context, int index) {
                                return item(favourites[1][index].menuItem,
                                    favourites[1][index]);
                              }),
                    ),
                  )))),
    );
  }
}
