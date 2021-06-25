
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wakaman_app/screens/home.dart';
import 'package:url_launcher/url_launcher.dart';

import 'Main.dart';


class ContactAndValidate extends StatefulWidget {
  String service_type;

  ContactAndValidate(this.service_type);


  @override
  MapScreenState createState() => MapScreenState(service_type);
}

class MapScreenState extends State<ContactAndValidate>
    with SingleTickerProviderStateMixin {
  bool _status = true;
  final FocusNode myFocusNode = FocusNode();
  String  mUserName, mEmailAddress;
  String service_type;

  MapScreenState(this.service_type);


  @override
  void initState() {
    super.initState();
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
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
      body: Container(
        child: Stack(
          children: <Widget>[


            Column(
              children: <Widget>[

                Expanded(
                  flex: 1,
                  child:SvgPicture.asset('assets/ccc_images/footer.svg', fit: BoxFit.fill),
                ),

                Expanded(
                  flex: 20,
                  child:new Container(
                    color: Colors.white,
                    child: new ListView(
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            new Container(
                              color: Color(0xffFFFFFF),
                              child: Padding(
                                padding: EdgeInsets.only(bottom: 25.0),
                                child: new Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                        padding: EdgeInsets.only(
                                            left: 25.0, right: 25.0, top: 25.0),
                                        child: new Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          mainAxisSize: MainAxisSize.max,
                                          children: <Widget>[
                                            new Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                new Text(
                                                  'Personal Information',
                                                  style: TextStyle(
                                                      fontSize: 18.0,
                                                      fontWeight: FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ],
                                        )),
                                    Padding(
                                        padding: EdgeInsets.only(
                                            left: 25.0, right: 25.0, top: 25.0),
                                        child: new Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: <Widget>[
                                            new Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                new Text(
                                                  'Name',
                                                  style: TextStyle(
                                                      fontSize: 16.0,
                                                      fontWeight: FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ],
                                        )),
                                    Padding(
                                        padding: EdgeInsets.only(
                                            left: 25.0, right: 25.0, top: 2.0),
                                        child: new Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: <Widget>[
                                            new Flexible(
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Text(mUserName!=null? mUserName: 'no Name', ),
                                              ),
                                            ),
                                          ],
                                        )),
                                    Padding(
                                        padding: EdgeInsets.only(
                                            left: 25.0, right: 25.0, top: 25.0),
                                        child: new Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: <Widget>[
                                            new Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                new Text(
                                                  'Email ID',
                                                  style: TextStyle(
                                                      fontSize: 16.0,
                                                      fontWeight: FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ],
                                        )),
                                    Padding(
                                        padding: EdgeInsets.only(
                                            left: 25.0, right: 25.0, top: 2.0),
                                        child: new Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: <Widget>[
                                            new Flexible(
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Text(mEmailAddress!=null? mEmailAddress: 'no Email ID', ),
                                              ),
                                            ),
                                          ],
                                        )),
                                    Padding(
                                        padding: EdgeInsets.only(
                                            left: 25.0, right: 25.0, top: 25.0),
                                        child: new Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: <Widget>[
                                            new Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                new Text(
                                                  'Mobile',
                                                  style: TextStyle(
                                                      fontSize: 16.0,
                                                      fontWeight: FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ],
                                        )),
                                    Padding(
                                        padding: EdgeInsets.only(
                                            left: 25.0, right: 25.0, top: 2.0),
                                        child: new Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: <Widget>[
                                            new Flexible(
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Text(widget.service_type!=null? widget.service_type: 'no Number',),
                                              ),
                                            ),
                                          ],
                                        )),

                                    !_status ? _getActionButtons() : new Container(),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),

                ),

                Expanded(
                  flex: 1,
                  child:Container(
                    child: SvgPicture.asset('assets/ccc_images/header.svg', fit: BoxFit.fill),
                  ),
                ),

              ],
            ),


          ],
        ),
      ),
      floatingActionButton: Wrap( //will break to another line on overflow
        direction: Axis.horizontal, //use vertical to show  on vertical axis
        children: <Widget>[
          Container(
              margin:EdgeInsets.all(10),
              child: FloatingActionButton(
                onPressed: () async => await launch("https://wa.me/237675669236?text=Hello yan"),
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
                onPressed: (){
                  //action code for button 2
                },
                backgroundColor: Colors.deepPurpleAccent,
                child: Icon(Icons.add),
              )
          ), // button second

          Container(
              margin:EdgeInsets.all(10),
              child: FloatingActionButton(
                onPressed: (){
                  //action code for button 3
                },
                backgroundColor: Colors.deepOrangeAccent,
                child: Icon(Icons.add),
              )
          ), // button third

          // Add more buttons here
        ],
      ),
    );

  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    myFocusNode.dispose();
    super.dispose();
  }

  Widget _getActionButtons() {
    return Padding(
      padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 45.0),
      child: new Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: Container(
                  child: new RaisedButton(
                child: new Text("Save"),
                textColor: Colors.white,
                color: Colors.green,
                onPressed: () {
                  setState(() {
                    _status = true;
                    FocusScope.of(context).requestFocus(new FocusNode());
                  });
                },
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(20.0)),
              )),
            ),
            flex: 2,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Container(
                  child: new RaisedButton(
                child: new Text("Cancel"),
                textColor: Colors.white,
                color: Colors.red,
                onPressed: () {
                  setState(() {
                    _status = true;
                    FocusScope.of(context).requestFocus(new FocusNode());
                  });
                },
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(20.0)),
              )),
            ),
            flex: 2,
          ),
        ],
      ),
    );
  }

  Widget _getEditIcon() {
    return new GestureDetector(
      child: new CircleAvatar(
        backgroundColor: Color(0xff043b73),
        radius: 14.0,
        child: new Icon(
          Icons.edit,
          color: Colors.white,
          size: 16.0,
        ),
      ),
      onTap: () {
        setState(() {
          _status = false;
        });
      },
    );
  }
}
