import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noticias/noticias/bloc/noticias_bloc.dart';

import 'noticias_busqueda.dart';

class Buscar extends StatefulWidget {
  final TextEditingController busqueda = TextEditingController();

  Buscar({Key key}) : super(key: key);

  @override
  _BuscarState createState() => _BuscarState();
}

class _BuscarState extends State<Buscar> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mis Noticias'),
      ),
      body: BlocProvider(
        create: (context) => NoticiasBloc(),
        child: BlocConsumer<NoticiasBloc, NoticiasState>(
          listener: (context, state) {
            if (state is NoticiasErrorState) {
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.red,
                  content: Text(state.message),
                ),
              );
            }
          },
          builder: (context, state) {
            Widget resultadosWidget = Text("No hay resultados.");
            if (state is NoticiasSearchSuccessState &&
                state.searchResults.length > 0) {
              resultadosWidget =
                  NoticiasBusqueda(noticias: state.searchResults);
            }
            return Center(
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Busqueda",
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: widget.busqueda,
                            decoration: InputDecoration(
                              filled: true,
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        RaisedButton(
                          child: Text("Buscar"),
                          onPressed: () {
                            BlocProvider.of<NoticiasBloc>(context).add(
                              SearchEvent(query: widget.busqueda.text),
                            );
                          },
                        )
                      ],
                    ),
                    Expanded(child: resultadosWidget)
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
