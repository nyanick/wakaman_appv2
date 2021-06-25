

import 'package:flutter/material.dart';
import 'package:wakaman_app/detail.dart';
import 'package:wakaman_app/util/places.dart';
import 'package:wakaman_app/widgets/horizontal_place_item.dart';
import 'package:wakaman_app/widgets/icon_badge.dart';
import 'package:wakaman_app/widgets/search_bar.dart';
import 'package:wakaman_app/widgets/vertical_place_item.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import '../util/constants.dart';
import '../models/data.dart';
import 'SubmitRequest.dart';


class Home extends StatefulWidget {
  @override
  _Home createState() => _Home();
}

class _Home extends State<Home> {

  List<NavigationItem> navigationItems = getNavigationItemList();
  NavigationItem selectedItem;

  List<Place> places1 = getPlaceList();
  List<Services> services = getServicesList();
  List<Testimonials> testimonials = getTestimonialList();

  @override
  void initState() {
    super.initState();
    setState(() {
      selectedItem = navigationItems[0];
    });
  }


  SpeedDial buildSpeedDial() {
    return SpeedDial(
      /// both default to 16
      ///
      /*
      marginEnd: 18,
      marginBottom: 20,
      */
      // animatedIcon: AnimatedIcons.menu_close,
      // animatedIconTheme: IconThemeData(size: 22.0),
      /// This is ignored if animatedIcon is non null
      icon: Icons.chat,
      activeIcon: Icons.close,
      // iconTheme: IconThemeData(color: Colors.grey[50], size: 30),

      /// The label of the main button.
      // label: Text("Open Speed Dial"),
      /// The active label of the main button, Defaults to label if not specified.
      // activeLabel: Text("Close Speed Dial"),
      /// Transition Builder between label and activeLabel, defaults to FadeTransition.
      // labelTransitionBuilder: (widget, animation) => ScaleTransition(scale: animation,child: widget),
      /// The below button size defaults to 56 itself, its the FAB size + It also affects relative padding and other elements
      //buttonSize: 56.0,
      visible: true,

      /// If true user is forced to close dial manually
      /// by tapping main button and overlay is not rendered.
      closeManually: false,
      curve: Curves.bounceIn,
      overlayColor: Colors.black,
      overlayOpacity: 0.5,
      onOpen: () => print('OPENING DIAL'),
      onClose: () => print('DIAL CLOSED'),
      tooltip: 'Let\'s Chat',
      heroTag: 'Write us directly',
      backgroundColor: Colors.lightBlue.shade100,
      elevation: 8.0,
      //shape: CircleBorder(),

      // orientation: SpeedDialOrientation.Up,
      // childMarginBottom: 2,
      // childMarginTop: 2,
      children: [
        SpeedDialChild(
          //backgroundColor: Colors.red,
          label: 'Whatsapp',
          labelStyle: TextStyle(fontSize: 14.0),
          onTap: ()  async => await canLaunch("https://wa.me/237675669236?text=Hello Wakaman")? launch("https://wa.me/237675669236?text=Hello yan"):throw ("Kindly install whatsapp in your Mobile device"),
          child: Image.asset(
          "assets/icons/whatsapp1.png",
          fit: BoxFit.contain,
          ),
          onLongPress: () => print('WHATSAPP LONG PRESS'),
        ),
        SpeedDialChild(
          //backgroundColor: Colors.blue,
          label: 'Facebook',
          labelStyle: TextStyle(fontSize: 14.0),
          onTap: () async => await canLaunch("https://m.me/nde.y.che")? launch("https://m.me/nde.y.che"):throw ("Kindly install Facebook in your Mobile device"),
          child: Image.asset(
            "assets/icons/facebook.png",
            fit: BoxFit.contain,
          ),
          onLongPress: () => print('FACEBOOK LONG PRESS'),
        ),
        SpeedDialChild(
          //backgroundColor: Colors.green,
          label: 'Instagram',
          labelStyle: TextStyle(fontSize: 14.0),
          onTap: () async => await canLaunch("https://www.instagram.com/nde_yanick/")? launch("https://www.instagram.com/nde_yanick/"):throw ("Not found"),
          child: Image.asset(
            "assets/icons/instagram.png",
            fit: BoxFit.contain,
          ),
          onLongPress: () => print('INSTAGRAM LONG PRESS'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Waka-Man",
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: false,
        actions: <Widget>[

          Container(
            margin: EdgeInsets.only(left: 16, top: 8,),
            width: 60,
            child: CircleAvatar(
              backgroundImage: AssetImage('assets/images/profile.png'),
            ),
          ),


        ],
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 16, right: 16, top: 16,),
            child: TextField(
              enabled: false,
              decoration: InputDecoration(
                hintText: 'Search',
                hintStyle: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[400],
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    width: 0,
                    style: BorderStyle.none,
                  ),
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 24),
                suffixIcon: Padding(
                  padding: EdgeInsets.only(right: 24.0, left: 8.0),
                  child: Icon(
                    Icons.search,
                    color: Colors.grey[400],
                    size: 26,
                  ),
                ),
              ),
            ),
          ),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8,),
            child: Text(
              "Tourist/ other Travels",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child:Container(
              height: 200,
              padding: EdgeInsets.only(top: 5, left: 16,),
              child: ListView(
                physics: BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                children: buildPlaces(context),
              ),
            ),
          ),

/*
          buildHorizontalList(context),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8,),
            child: Text(
              "Traveler's Review",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
*/
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8,),
            child: Text(
              "Our Services",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child:Container(
              height: 150,
              padding: EdgeInsets.only(top: 8, left: 16,),
              child: ListView(
                physics: BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                children: buildDestinations(context),
              ),
            ),
          ),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8,),
            child: Text(
              "Job Opportunities",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          buildVerticalList(),
          Expanded(
            flex: 10,
            child:Container(
              height: 200,
              child: PageView(
                physics: BouncingScrollPhysics(),
                children: buildFeatureds(),
              ),
            ),
          ),

        ],
      ),
      floatingActionButton: buildSpeedDial(),
      /*
      floatingActionButton: Wrap( //will break to another line on overflow
        direction: Axis.horizontal, //use vertical to show  on vertical axis
        children: <Widget>[
          Container(
              margin:EdgeInsets.all(10),
              child: FloatingActionButton(
                //await canLaunch(whatsappUrl)? launch(whatsappUrl):print("open whatsapp app link or do a snackbar with notification that there is no whatsapp installed");
                onPressed: () async => await canLaunch("https://wa.me/237675669236?text=Hello yan")? launch("https://wa.me/237675669236?text=Hello yan"):throw ("Kindly install whatsapp in your Mobile device"),
                child: Image.asset(
                  "assets/icons/whatsapp1.png",
                  height: 50,
                  fit: BoxFit.fitHeight,
                ),
              )
          ), //button first

          Container(
              margin:EdgeInsets.all(10),
              child: FloatingActionButton(
                onPressed: () async => await canLaunch("https://m.me/nde.y.che")? launch("https://m.me/nde.y.che"):throw ("Kindly install Facebook in your Mobile device"),
                child: Image.asset(
                  "assets/icons/facebook.png",
                  height: 50,
                  fit: BoxFit.fitHeight,
                ),
              )
          ), // button second

          Container(
              margin:EdgeInsets.all(10),
              child: FloatingActionButton(
                onPressed: () async => await canLaunch("https://www.instagram.com/nde_yanick/")? launch("https://www.instagram.com/nde_yanick/"):throw ("Not found"),
                child: Image.asset(
                  "assets/icons/instagram.png",
                  height: 50,
                  fit: BoxFit.fitHeight,
                ),
              )
          ), // button third

          // Add more buttons here
        ],
      ),
      */
    );
  }

  buildHorizontalList(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 10.0, left: 20.0),
      height: 250.0,
      width: MediaQuery.of(context).size.width,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        primary: false,
        itemCount: places == null ? 0.0 : places.length,
        itemBuilder: (BuildContext context, int index) {
          Map place = places.reversed.toList()[index];
          return HorizontalPlaceItem(place: place);
        },
      ),
    );
  }

  buildVerticalList() {
    return Padding(
      padding: EdgeInsets.all(20.0),
      child: ListView.builder(
        primary: false,
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: places == null ? 0 : places.length,
        itemBuilder: (BuildContext context, int index) {
          Map place = places[index];
          return VerticalPlaceItem(place: place);
        },
      ),
    );
  }




  List<Widget> buildPlaces(BuildContext context){
    List<Widget> list = [];
    for (var place in places1) {
      list.add(buildPlace(place,context));
    }
    return list;
  }

  Widget buildPlace(Place place,BuildContext context){
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Detail(place: place)),
        );
      },
      child: Card(
        elevation: 2,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(15),
          ),
        ),
        child: Hero(
          tag: place.images[0],
          child: Container(
            width: 230,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(place.images[0]),
                fit: BoxFit.cover,
              ),
            ),
            child: Stack(
              children: <Widget>[

                GestureDetector(
                  onTap: () {
                    setState(() {
                      place.favorite = !place.favorite;
                    });
                  },
                  child: Padding(
                    padding: EdgeInsets.only(left: 12, top: 12,),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Icon(
                        place.favorite ? Icons.favorite : Icons.favorite_border,
                        color: kPrimaryColor,
                        size: 36,
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(left: 12, bottom: 12, right: 12,),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[

                        Text(
                          place.description,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),

                        SizedBox(
                          height: 8,
                        ),

                        Row(
                          children: <Widget>[

                            Icon(
                              Icons.location_on,
                              color: Colors.white,
                              size: 20,
                            ),

                            SizedBox(
                              width: 8,
                            ),

                            Text(
                              place.country,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),

                          ],
                        ),

                      ],
                    ),
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> buildDestinations(BuildContext context){
    List<Widget> list = [];
    for (var service in services) {
      list.add(buildServices(service, context));
    }
    return list;
  }

  Widget buildServices(Services services,BuildContext context){

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SubmitRequest(title:services.title)),
        );
      },
      child: Card(
        elevation: 2,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(15),
          ),
        ),
        child: Container(
          width: 150,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 18, vertical: 5,),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  services.iconUrl,
                  height: 35,
                  fit: BoxFit.fitHeight,
                  color: services.iconColor,
                ),

                SizedBox(
                  height: 4,
                ),

                Text(
                  services.title,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(
                  height: 4,
                ),

                Text(
                  services.subtitle,
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 12,
                  ),
                ),

              ],
            ),
          ),
        ),
      ),);
  }

  List<Widget> buildFeatureds(){
    List<Widget> list = [];
    for (var testimonies in testimonials) {
      list.add(buildFeatured(testimonies));
    }
    return list;
  }

  Widget buildFeatured(Testimonials testimonies){
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12,),
      child: Card(
        elevation: 0,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(15),
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(testimonies.imageUrl),
              fit: BoxFit.fill,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16,),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[

                Text(
                  testimonies.year,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                SizedBox(
                  height: 4,
                ),

                Text(
                  testimonies.title,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> buildNavigationItems(){
    List<Widget> list = [];
    for (var navigationItem in navigationItems) {
      list.add(buildNavigationItem(navigationItem));
    }
    return list;
  }

  Widget buildNavigationItem(NavigationItem item){
    return GestureDetector(
      onTap: () {
        //
      },
      child: Container(
        width: 50,
        child: Stack(
          children: <Widget>[

            Align(
              alignment: Alignment.topCenter,
              child: Container(
                width: 40,
                height: 3,
                color: selectedItem == item ? kPrimaryColor : Colors.transparent,
              ),
            ),

            Center(
              child: Icon(
                item.iconData,
                color: selectedItem == item ? kPrimaryColor : Colors.grey[400],
                size: 28,
              ),
            )

          ],
        ),
      ),
    );
  }
}


