import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noticias/mis_noticias/bloc/mis_noticias_bloc.dart';

class ImageSourceWidget extends StatefulWidget {
  final MisNoticiasBloc bloc;
  ImageSourceWidget({Key key, @required this.bloc}) : super(key: key);

  @override
  _ImageSourceWidgetState createState() => _ImageSourceWidgetState();
}

class _ImageSourceWidgetState extends State<ImageSourceWidget> {
  void _pickImage(bool takePictureFromCamera) {
    widget.bloc.add(
      CargarImagenEvent(takePictureFromCamera: takePictureFromCamera),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: new Wrap(
        children: <Widget>[
          new ListTile(
            leading: new Icon(Icons.photo_library),
            title: new Text('Galería'),
            onTap: () {
              Navigator.pop(context);
              _pickImage(false);
            },
          ),
          new ListTile(
            leading: new Icon(Icons.camera),
            title: new Text('Cámara'),
            onTap: () {
              Navigator.pop(context);
              _pickImage(true);
            },
          ),
        ],
      ),
    );
  }
}

class CrearNoticia extends StatefulWidget {
  CrearNoticia({Key key}) : super(key: key);

  @override
  _CrearNoticiaState createState() => _CrearNoticiaState();
}

class _CrearNoticiaState extends State<CrearNoticia> {
  TextEditingController titulo = TextEditingController();
  TextEditingController autor = TextEditingController();
  TextEditingController descripcion = TextEditingController();
  TextEditingController fuente = TextEditingController();
  bool imagenCargada = false;
  Widget widgetImagen = Placeholder(
    fallbackHeight: 128,
    fallbackWidth: 128,
  );
  void _selectImageSource(context) {
    MisNoticiasBloc _bloc = BlocProvider.of<MisNoticiasBloc>(context);
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return ImageSourceWidget(bloc: _bloc);
      },
    );
  }

  void _clearFields() {
    titulo.clear();
    descripcion.clear();
    autor.clear();
    fuente.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider<MisNoticiasBloc>(
        create: (context) => MisNoticiasBloc(),
        child: BlocConsumer<MisNoticiasBloc, MisNoticiasState>(
            listener: (context, state) {
          imagenCargada = state is ImagenCargadaState;
          if (state is NoticiasErrorState) {
            Scaffold.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Colors.red,
                content: Text(state.errorMessage),
              ),
            );
            _clearFields();
          }
          if (state is NoticiasCreadaState) {
            Scaffold.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Colors.green,
                content: Text("Noticia creada"),
              ),
            );
            _clearFields();
          }
          if (state is ImagenCargadaState) {
            widgetImagen = SizedBox(
              height: 128,
              child: Image.file(state.imagen),
            );
          } else {
            widgetImagen = Placeholder(
              fallbackHeight: 128,
              fallbackWidth: 128,
            );
          }
        }, builder: (context, state) {
          return SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    widgetImagen,
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Titulo",
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    ),
                    TextField(
                      controller: titulo,
                      decoration: InputDecoration(
                        filled: true,
                        border: OutlineInputBorder(),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Autor",
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    ),
                    TextField(
                      controller: autor,
                      decoration: InputDecoration(
                          filled: true, border: OutlineInputBorder()),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Descripcion",
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    ),
                    TextField(
                      controller: descripcion,
                      minLines: 2,
                      maxLines: 5,
                      decoration: InputDecoration(
                        filled: true,
                        border: OutlineInputBorder(),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Fuente",
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    ),
                    TextField(
                      controller: fuente,
                      decoration: InputDecoration(
                          filled: true, border: OutlineInputBorder()),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Imagen",
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    ),
                    RaisedButton(
                      child: Text("Seleccionar Imagen"),
                      onPressed: () {
                        _selectImageSource(context);
                      },
                    ),
                    RaisedButton(
                      child: Text("Crear Noticia"),
                      onPressed: !imagenCargada
                          ? null
                          : () {
                              BlocProvider.of<MisNoticiasBloc>(context).add(
                                CrearNoticiaEvent(
                                  titulo: titulo.text,
                                  descripcion: descripcion.text,
                                  autor: autor.text,
                                  fuente: fuente.text,
                                ),
                              );
                            },
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
