import 'package:flutter/material.dart';
import 'package:noticias/models/noticia.dart';

class NoticiaDeportes extends StatefulWidget {
  final List<Noticia> noticias;
  NoticiaDeportes({Key key, @required this.noticias}) : super(key: key);

  @override
  _NoticiaDeportesState createState() => _NoticiaDeportesState();
}

class _NoticiaDeportesState extends State<NoticiaDeportes> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: Text("Deportes de la semana: ${widget.noticias}"),
        ),
      ),
    );
  }
}
