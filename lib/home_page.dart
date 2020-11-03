import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noticias/noticias/noticia_deportes.dart';
import 'package:noticias/noticias/noticia_negocios.dart';

import 'noticias/bloc/noticias_bloc.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _tabsList = [
    Tab(icon: Icon(Icons.article), text: "Deportes"),
    Tab(icon: Icon(Icons.description), text: "Negocios"),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Noticias de la semana'),
          bottom: TabBar(
            tabs: _tabsList,
          ),
        ),
        body: BlocProvider(
          create: (context) => NoticiasBloc()..add(GetNewsEvent()),
          child: BlocConsumer<NoticiasBloc, NoticiasState>(
            listener: (context, state) {
              //
            },
            builder: (context, state) {
              if (state is NoticiasSuccessState) {
                return TabBarView(
                  children: [
                    NoticiaDeportes(noticias: state.noticiasSportList),
                    NoticiaNegocios(noticias: state.noticiasBusinessList),
                  ],
                );
              }
              return Center(
                child: Text("No hay noticias disponibles"),
              );
            },
          ),
        ),
      ),
    );
  }
}
