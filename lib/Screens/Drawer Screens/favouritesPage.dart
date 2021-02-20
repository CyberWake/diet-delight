import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:diet_delight/Models/addFavouritesModel.dart';
import '../../Models/foodItemModel.dart';
import 'package:diet_delight/services/apiCalls.dart';
import '../../konstants.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class FavouritesPage extends StatefulWidget {
  @override
  _FavouritesPageState createState() => _FavouritesPageState();
}

class _FavouritesPageState extends State<FavouritesPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<List> favourites = List();
  List<int> favPressed = List();
  final _apiCall = Api.instance;
  ScrollController _scrollController = new ScrollController();
  bool isLoaded = false;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    await getData();
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    setState(() {});
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  Widget item(FoodItemModel foodItem, AddFavouritesModel details) {
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
//                      Text(
//                        foodItem.des,
//                        style: appBarTextStyle.copyWith(
//                            fontSize: 12,
//                            fontWeight: FontWeight.w400,
//                            color: Color.fromRGBO(144, 144, 144, 1)),
//                      ),
                      SizedBox(
                        height: 4,
                      ),
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
                                size: 13, color: defaultPurple)),
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Container(
                  margin: EdgeInsets.only(right: 20),
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

  Future getData() async {
    setState(() {
      isLoaded = false;
    });
    favourites = await _apiCall.getFavourites();
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
    return SafeArea(
      child: Container(
          child: isLoaded == false
              ? Center(child: CircularProgressIndicator())
              : Scaffold(
                  key: _scaffoldKey,
                  backgroundColor: white,
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
                      child: ListView.builder(
                          controller: _scrollController,
                          itemCount: favourites[1].length,
                          itemBuilder: (BuildContext context, int index) {
                            return item(favourites[1][index].menuItem,
                                favourites[1][index]);
                          }),
                    ),
//      ListView(
//        children: [
//          Padding(
//            padding: const EdgeInsets.only(top: 18.0),
//            child: item(dummyModel),
//          )
//        ],
//      ),
                  )))),
    );
  }
}
