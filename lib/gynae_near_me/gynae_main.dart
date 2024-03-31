import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'nearby_response.dart';
import '../components/primary_appbar.dart';
import '../confidential.dart';
import 'geo_coder_model.dart';
import 'package:http/http.dart' as http;

class GynaeMain extends StatefulWidget {
  const GynaeMain({super.key});

  @override
  State<GynaeMain> createState() => _GynaeMainState();
}

class _GynaeMainState extends State<GynaeMain> {
  double? lat;
  double? lon;
  String? address;
  final latlongurl =
      'http://api.positionstack.com/v1/forward?access_key=${addressLatLongKey}&query=';
  late GeoCoderModel latlong;
  late Places placesData;
  bool gotLocation = false;
  StreamController? _streamController;
  Stream? _stream;
  final TextEditingController myController = TextEditingController();
  Timer? _debounce;
  List<dynamic> gynaes = [];

  @override
  void initState() {
    super.initState();
    _streamController = StreamController.broadcast();
    _stream = _streamController!.stream;
  }

  getAPI() async {
    if (myController.text == null || myController.text.isEmpty) {
      _streamController!.add(null);
      return;
    }

    _streamController!.add("Loading...");
    print("In get API");
    final latlongresponse = await http
        .get(Uri.parse(latlongurl + myController.text.replaceAll(' ', '+')));
    // print("LatLongResponse = ${latlongresponse}");
    var latlongdata = jsonDecode(latlongresponse.body.toString());
    print(latlongdata);

    latlong = GeoCoderModel.fromJson(latlongdata);
    if (latlong.data == null || latlong.data!.isEmpty) return;
    lat = latlong.data![0].latitude;
    lon = latlong.data![0].longitude;
    print("Latitude = ${lat}");
    print("Longitude = ${lon}");
    final response = await http.get(
        Uri.parse(
            "https://api.foursquare.com/v3/places/search?query=gynaecologist&ll=${lat}%2C${lon}&radius=20000"),
        headers: {"Authorization": placesKey});
    var data = jsonDecode(response.body.toString());
    print(data);
    _streamController!.add(data);
    placesData = Places.fromJson(data);
    print("Got Places data as ${placesData}");
    print(" and of length ${placesData.results!.length}");
    for (int i = 0; i < placesData.results!.length; i++) {
      gynaes.add({
        "distance": "${placesData.results![i].distance! / 1000}km",
        "address": placesData.results![i].location!.formattedAddress!,
        // "addressLine2": placesData.results![i].location!.addressExtended!,
        "name": placesData.results![i].name!,
      });
    }
    print(gynaes);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        child: PrimaryAppBar(
          page: 'homepage',
        ),
        preferredSize: const Size.fromHeight(60.0),
      ),
      body: ListView(
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text("Address", style: TextStyle(fontFamily: 'Inria', fontSize: 20))
          ),
          Flexible(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              margin: EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border.all(width: 1),
                borderRadius: BorderRadius.circular(15)
              ),
              child: TextFormField(
                onChanged: (String text) async {
                  if (_debounce?.isActive ?? false) _debounce!.cancel();
                  _debounce = Timer(const Duration(milliseconds: 1000), () {
                    getAPI();
                  });
                },
                controller: myController,
                decoration: const InputDecoration(
                  icon: Icon(Icons.search),
                  hintText: "Enter an address..",
                  contentPadding: EdgeInsets.only(left: 24.0),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          StreamBuilder(
              stream: _stream,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.data == null) {
                  return Container();
                }

                if (snapshot.data == "Loading...") {
                  return Center(
                    child: Column(
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 300),
                      ],
                    ),
                  );
                }
                if (snapshot.hasData) {
                  final data = snapshot.data;
                  if (data["results"].length == 0) {
                    return const Text('Type a nearby place');
                  }
                  return SizedBox(
                    height: MediaQuery.of(context).size.height * 1.5,
                    child: ListView.builder(
                        itemCount: gynaes!.length,
                        itemBuilder: (ctx, index) => GynaeCard(
                              snap: gynaes![index],
                            )),
                  );
                }
                return Container();
              }),
        ],
      ),
    );
  }
}

class GynaeCard extends StatelessWidget {
  final snap;
  const GynaeCard({Key? key, required this.snap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('Data');
    print(snap);
    return Card(
        color: Colors.pink[50],
        shadowColor: Colors.pink[400],
        margin: EdgeInsets.all(20),
        child: Column(children: [
          Container(
            padding: EdgeInsets.all(10),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  decoration: BoxDecoration(
                      color: Colors.pink[300],
                      borderRadius: BorderRadius.circular(20)),
                  child: Row(children: [
                    Icon(
                      Icons.person,
                      color: Colors.white,
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Name: ',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ]),
                ),
                SizedBox(width: 10),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2,
                  child: Text(
                    '${snap['name']}',
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(10),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  decoration: BoxDecoration(
                      color: Colors.pink[300],
                      borderRadius: BorderRadius.circular(20)),
                  child: Row(children: [
                    Icon(
                      Icons.home,
                      color: Colors.white,
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Address: ',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ]),
                ),
                SizedBox(width: 10),
                SizedBox(
                  width: MediaQuery.of(context).size.width/2.5,
                  child: Text(
                    '${snap['address']}',
                    style: TextStyle(color: Colors.black, fontSize: 16),
                    softWrap: true,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(10),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  decoration: BoxDecoration(
                      color: Colors.pink[300],
                      borderRadius: BorderRadius.circular(20)),
                  child: Row(children: [
                    Icon(
                      Icons.pin_drop,
                      color: Colors.white,
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Distance: ',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ]),
                ),
                SizedBox(width: 10),
                Text(
                  '${snap['distance']}',
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
              ],
            ),
          ),
        ]));
  }
}

