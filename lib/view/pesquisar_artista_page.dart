// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_field

import 'package:apk_spotify_api/service/spotify_service.dart';
import 'package:flutter/material.dart';

class PesquisarArtistaPage extends StatefulWidget {
  final String? access_token;
  const PesquisarArtistaPage({Key? key, this.access_token}) : super(key: key);

  @override
  State<PesquisarArtistaPage> createState() => _PesquisarArtistaPageState();
}

class _PesquisarArtistaPageState extends State<PesquisarArtistaPage> {
  String? campo; 
  Future<Map>? futureResultado;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 120, 0, 233),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(width: 60),
            Image.asset(
              'assets/imgs/spotify_logo_black.png', 
              fit: BoxFit.contain, 
              height: 40,
              ),
          ],
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            const SizedBox(height: 30),
            TextField(
              decoration: InputDecoration(
                labelText: "Pesquise um Artista",
                labelStyle: TextStyle(color: const Color.fromARGB(255, 120, 0, 233)),
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.text,
              style: TextStyle(color: Colors.white, fontSize: 18),
              onSubmitted: (value) {
                setState(() {
                  campo = value;
                  futureResultado = pesquisarArtistas(widget.access_token, campo);
                });
              },
            ),
            Expanded(
              child: futureResultado == null
                  ? Center(
                      child: Text(
                        "Pesquise um artista para começar.",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    )
                  : FutureBuilder(
                      future: futureResultado,
                      builder: (context, snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
                            return Center(
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white),
                              ),
                            );
                          default:
                            if (snapshot.hasError) {
                              return Center(
                                child: Text(
                                  "Erro ao buscar o artista.",
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 16,
                                  ),
                                ),
                              );
                            } else {
                              return exibeResultado(context, snapshot);
                            }
                        }
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget exibeResultado(BuildContext context, AsyncSnapshot snapshot){
    if (snapshot.data["artists"]["items"].isEmpty) {
      return Center(
        child: Text(
          "Nenhum artista encontrado.",
          style: TextStyle(color: const Color.fromARGB(255, 120, 0, 233), fontSize: 16),
        ),
      );
    }
    var artist = snapshot.data["artists"]["items"][0];
    var imageUrl = artist["images"].isNotEmpty ? artist["images"][0]["url"] : null;
    var followers = artist["followers"]["total"].toString();
    var genres = artist["genres"];
    var formattedGenres = genres.isNotEmpty ? genres.join(", ") : "Nenhum gênero disponível";

    return Padding(
      padding: EdgeInsets.only(top: 10.0),
      child: Column(
        children: [
          const SizedBox(height: 30.0),
          Text(
            artist["name"],
            style: TextStyle(
              color: const Color.fromARGB(255, 120, 0, 233), fontSize: 28.0, fontWeight: FontWeight.bold
            ),
          ),
          const SizedBox(height: 5.0),
          if (imageUrl != null)
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.white,
                width: 2.0, // Largura da borda
              ),
            ),
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover, 
              width: 200,
              height: 200, 
            ),
          ),
          const SizedBox(height: 20),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "Seguidores: ",
                  style: TextStyle(
                    color: const Color.fromARGB(255, 120, 0, 233),
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: followers,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "Gêneros: ",
                  style: TextStyle(
                    color: const Color.fromARGB(255, 120, 0, 233),
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: formattedGenres,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                  ),
                ),
              ],
            ),
          )
        ],
      ) 
    );
  }
}