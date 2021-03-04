import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      title: 'Voyages',

      theme: ThemeData(
        fontFamily: 'RobotoMono',
        primarySwatch: Colors.teal,
      ),
      home: AccueilForfaitsVoyages(title: 'Voyages'),

    );
  }
}


class AccueilForfaitsVoyages extends StatefulWidget {
  AccueilForfaitsVoyages({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  AccueilForfaitsVoyagesState createState() => AccueilForfaitsVoyagesState();
}

class AccueilForfaitsVoyagesState extends State<AccueilForfaitsVoyages> {
  late Future<List<Forfait>> futurForfaits;
  List<Forfait> forfaits = [];



  initState() {
    super.initState();
    futurForfaits = _fetchForfaits();

  }

  Future<List<Forfait>> _fetchForfaits() async {
    final response = await http.get(Uri.https(
        'forfaits-voyages.herokuapp.com', '/api/forfaits/da/1996489', {}));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((forfait) => new Forfait.fromJson(forfait))
          .toList();
    } else {
      throw Exception('Erreur de chargement des forfaits');
    }
  }


  @override
  Widget build(BuildContext context) {

    Widget fieldDestination(destination, villeDepart) { //Field Destination
      return Container(
          padding: const EdgeInsets.all(25),
          child:
          Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(bottom: 5, right: 5),
                      child: Text(
                        destination,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      "Ville de Départ: " + villeDepart,
                      style: TextStyle(
                        color: Colors.orange,
                      ),
                    ),
                  ],
                ),
              ],
          ),
      );
    }

    Widget fieldHotel(Hotel hotel) { //Field Hotel
      return Container(
          padding: const EdgeInsets.only(left: 15, top: 30, bottom: 10),
          child:
          Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(bottom: 2),
                      child:
                      Text(
                        hotel.nom,
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Container(
                        padding: const EdgeInsets.only(bottom: 20),
                        child:
                        Row(children: [
                          Icon(Icons.add_location_sharp, color: Colors.teal),
                          Text(hotel.coordonnees),
                        ],
                        )
                    ),

                    Container(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Text(
                            hotel.nombreChambres.toString() + " Chambres"),

                    ),
                  ],
                ),
              ],
          ),
      );
    }

    Widget fieldPrix(prix, rabais) {  //Field Prix
      return Container(
          child:
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  Container(
                      padding: const EdgeInsets.only( top:10, bottom: 10),
                      child:
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text((prix - rabais).toString() + "\$",
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),

                          Text(
                            "tx. et frais incl. par adulte",
                              style: TextStyle(
                              color: Colors.orange,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(rabais > 0 ? (prix).toString() + "\$" : "",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.redAccent,

                    ),
                  ),
                ],
              ),

              Row(
                children: [
                  Text("Prix final: " + (rabais > 0 ? rabais.toString() + "\$" : ""),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  )
                ],
              ),
            ],
          ),
      );
    }


    return FutureBuilder<List<Forfait>>(

      future: futurForfaits,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                title: Text(widget.title),
              ),
              body:
              ListView.builder(
                  padding: const EdgeInsets.only(bottom: 25),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return
                      Container(
                          padding: const EdgeInsets.only(
                              top: 24, left: 24, right: 24),
                          child:
                          Container(
                            decoration: new BoxDecoration(
                              border: new Border.all(color: snapshot.data![index].vedette ?
                              Theme.of(context).primaryColor : Colors.grey, width: 1),
                              color: Colors.white,
                              borderRadius: BorderRadius.all(
                                Radius.circular(25),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: snapshot.data![index].vedette ?
                                  Theme.of(context).primaryColor : Colors.teal,
                                  blurRadius: 3,
                                  offset: Offset(3,
                                      4),
                                ),
                              ],
                            ),

                            child: Column(
                                children: [

                                  Row(
                                    children: [
                                      Expanded(
                                          child:
                                          ClipRRect(
                                              borderRadius: new BorderRadius.only(
                                                topLeft: const Radius.circular(
                                                    24),
                                                topRight: const Radius.circular(
                                                    24),
                                              ),
                                              child: Image.network(
                                                "https://picsum.photos/600/240",
                                                width: 600,
                                                height: 240,
                                                fit: BoxFit.cover,
                                              )
                                          )
                                      )
                                    ],
                                  ),
                                  Container(
                                      decoration: new BoxDecoration(
                                        color: snapshot.data![index].vedette?
                                        Colors.tealAccent[700]
                                            : Theme
                                            .of(context).primaryColor,
                                      ),
                                      padding: snapshot.data![index].vedette
                                          ? const EdgeInsets.only(
                                          top: 10, bottom: 10)
                                          : const EdgeInsets.only(
                                          top: 5, bottom: 5),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children:
                                        [ snapshot.data![index].vedette ?
                                        Text("Forfait vedette",
                                          style: TextStyle(
                                            fontSize: 20,
                                            //fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        )
                                            :
                                        Container()
                                        ],
                                      )
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      fieldHotel(snapshot.data![index].hotel),
                                      Column(
                                        children: [
                                          Row(
                                              children: [
                                                fieldDestination(
                                                    snapshot.data![index].destination,
                                                    snapshot.data![index].villeDepart),
                                              ]),

                                          Row(
                                              children: [
                                                fieldPrix(
                                                    snapshot.data![index].prix,
                                                    snapshot.data![index].rabais),
                                              ]),
                                        ],)
                                    ],
                                  ),
                                  Container(
                                      padding: const EdgeInsets.only(
                                          left: 15, bottom: 50, right: 30),
                                      child:
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment
                                            .start,
                                        children: [
                                          Container(
                                              padding: const EdgeInsets.only(
                                                  right: 25),
                                              child:
                                              Column(
                                                  crossAxisAlignment: CrossAxisAlignment
                                                      .start,
                                                  children: [
                                                    Row(
                                                        children: [
                                                          Text('Départ' ,
                                                            style: TextStyle(
                                                              color: Colors.black,
                                                              fontSize: 20.0,
                                                              fontWeight: FontWeight.bold,
                                                            ),
                                                          ),
                                                        ]
                                                    ),
                                                    Row(
                                                        children: [
                                                          Text( (snapshot.data?[index].dateDepart.toString() ?? ''),
                                                            style: TextStyle(
                                                              color: Colors.black,
                                                              fontSize: 15.0,
                                                            ),
                                                          )
                                                        ]
                                                    ),
                                                  ]
                                              )
                                          ),

                                          Column(
                                              crossAxisAlignment: CrossAxisAlignment
                                                  .start,

                                              children: [
                                                Row(

                                                    children: [
                                                      Text("Retour:",
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 20.0,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      )
                                                    ]
                                                ),
                                                Row(
                                                    children: [
                                                      Text('Retour ' +
                                                          (snapshot.data?[index].dateRetour.toString() ?? ''),
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 15.0,
                                                        ),
                                                      )
                                                    ]
                                                ),
                                              ]
                                          )
                                        ],
                                      )
                                  )
                                ]
                            ),
                          )
                      );
                  }
              )
          );
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return LinearProgressIndicator();
      },
    );
  }
}
  class Forfait {
  final String id;
  final String destination;
  final String villeDepart;
  final DateTime dateDepart;
  final DateTime dateRetour;
  final String image;
  final int prix;
  final int rabais;
  final bool vedette;
  final Hotel hotel;

  Forfait({required this.id, required this.destination,required this.villeDepart,required this.hotel,required this.dateDepart,required this.dateRetour, required this.image,required this.prix,required this.rabais,required this.vedette});

  factory Forfait.fromJson(Map<String, dynamic> json) {
    return Forfait(
      id: json['_id'],
      destination: json['destination'],
      villeDepart: json['villeDepart'],
      dateDepart: DateTime.parse("2021-01-01"),
      dateRetour: DateTime.parse("2021-01-01"),
      image: json['image'],
      prix: json['prix'],
      rabais: json['rabais'],
      vedette: json['vedette'],
      hotel:Hotel.fromJson(json['hotel']),

    );
  }

}
class Hotel {
  final String nom;
  final String coordonnees;
  final int nombreEtoiles;
  final int nombreChambres;
  final List<String> caracteristiques;

  Hotel({required this.nom,required this.coordonnees,required this.nombreEtoiles,required this.nombreChambres,required this.caracteristiques});

  factory Hotel.fromJson(Map<String, dynamic> json) {
    return Hotel(
        nom:json['nom'],
        coordonnees:json['coordonnees'],
        nombreEtoiles: json['nombreEtoiles'],
        nombreChambres: json['nombreChambres'],
        caracteristiques: new List<String>.from(json['caracteristiques'])
    );
  }
}

