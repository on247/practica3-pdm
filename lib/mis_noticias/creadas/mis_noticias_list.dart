import 'package:flutter/material.dart';
import 'package:noticias/mis_noticias/bloc/mis_noticias_bloc.dart';
import 'package:noticias/noticias/item_noticia.dart';

class MisNoticiasList extends StatefulWidget {
  final MisNoticiasBloc bloc;
  MisNoticiasList({Key key, @required this.bloc}) : super(key: key);

  @override
  _MisNoticiasListState createState() => _MisNoticiasListState();
}

class _MisNoticiasListState extends State<MisNoticiasList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView.builder(
          itemCount: widget.bloc.listaNoticias.length,
          itemBuilder: (BuildContext context, int index) {
            return ItemNoticia(noticia: widget.bloc.listaNoticias[index]);
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            widget.bloc.add(LeerNoticiasEvent());
            setState(() {});
          },
          child: Icon(Icons.refresh),
        ));
  }
}
