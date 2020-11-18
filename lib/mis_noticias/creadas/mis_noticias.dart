import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noticias/mis_noticias/bloc/mis_noticias_bloc.dart';
import 'package:noticias/mis_noticias/creadas/mis_noticias_list.dart';

class MisNoticias extends StatefulWidget {
  const MisNoticias({Key key}) : super(key: key);

  @override
  _MisNoticiasState createState() => _MisNoticiasState();
}

class _MisNoticiasState extends State<MisNoticias> {
  void refresh() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mis Noticias'),
      ),
      body: BlocProvider(
        create: (context) => MisNoticiasBloc()..add(LeerNoticiasEvent()),
        child: BlocConsumer<MisNoticiasBloc, MisNoticiasState>(
          listener: (context, state) {
            if (state is NoticiasErrorState) {
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.red,
                  content: Text(state.errorMessage),
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is NoticiasDescargadasState) {
              return MisNoticiasList(
                bloc: BlocProvider.of<MisNoticiasBloc>(context),
              );
            }
            return Center(
              child: Text("No hay noticias disponibles"),
            );
          },
        ),
      ),
    );
  }
}
