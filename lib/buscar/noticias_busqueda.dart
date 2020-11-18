import 'package:flutter/material.dart';
import 'package:noticias/models/noticia.dart';
import 'package:noticias/noticias/item_noticia.dart';

class NoticiasBusqueda extends StatefulWidget {
  final List<Noticia> noticias;
  NoticiasBusqueda({Key key, @required this.noticias}) : super(key: key);

  @override
  _NoticiasBusquedaState createState() => _NoticiasBusquedaState();
}

class _NoticiasBusquedaState extends State<NoticiasBusqueda> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: widget.noticias.length,
        itemBuilder: (BuildContext context, int index) {
          return ItemNoticia(noticia: widget.noticias[index]);
        },
      ),
    );
  }
}
