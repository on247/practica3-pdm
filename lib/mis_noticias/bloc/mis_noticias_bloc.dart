import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:noticias/models/noticia.dart';
import 'package:noticias/models/source.dart' as Source;
import 'package:path/path.dart' as Path;
part 'mis_noticias_event.dart';
part 'mis_noticias_state.dart';

class MisNoticiasBloc extends Bloc<MisNoticiasEvent, MisNoticiasState> {
  List<Noticia> _noticiasList;
  List<Noticia> get listaNoticias => _noticiasList;
  File chosenImage;
  MisNoticiasBloc() : super(MisNoticiasInitial());

  @override
  Stream<MisNoticiasState> mapEventToState(
    MisNoticiasEvent event,
  ) async* {
    if (event is LeerNoticiasEvent) {
      try {
        await _getAllNoticias();
        yield NoticiasDescargadasState();
      } catch (e) {
        yield NoticiasErrorState(
            errorMessage: "No se pudo descargar las noticias");
      }
    } else if (event is CargarImagenEvent) {
      File _newChosenImage = await _chooseImage(event.takePictureFromCamera);
      if (_newChosenImage == null) {
        if (chosenImage == null) {
          yield MisNoticiasInitial();
        }
      } else {
        chosenImage = _newChosenImage;
      }
      yield ImagenCargadaState(imagen: chosenImage);
    } else if (event is CrearNoticiaEvent) {
      try {
        String imageUrl = await _uploadPicture(chosenImage);
        await _saveNoticia(event.titulo, event.descripcion, event.autor,
            event.fuente, imageUrl);
        yield NoticiasCreadaState();
      } catch (e) {
        yield NoticiasErrorState(errorMessage: "No se pudo guardar la noticia");
      }
    }
  }

  Future _getAllNoticias() async {
    // recuperar lista de docs guardados en Cloud firestore
    // agregar cada ojeto a una lista
    var misNoticias =
        await FirebaseFirestore.instance.collection("noticias").get();

    _noticiasList = misNoticias.docs
        .map(
          (elemento) => Noticia(
            title: elemento["titulo"],
            description: elemento["descripcion"],
            author: elemento["autor"],
            source:
                Source.Source(id: elemento["fuente"], name: elemento["fuente"]),
            urlToImage: elemento["imagen"],
            publishedAt: elemento["fecha"],
          ),
        )
        .toList();
  }

  Future<File> _chooseImage(bool fromCamera) async {
    final picker = ImagePicker();
    final PickedFile chooseImage = await picker.getImage(
      source: fromCamera ? ImageSource.camera : ImageSource.gallery,
      maxHeight: 720,
      maxWidth: 720,
      imageQuality: 85,
    );
    if (chooseImage == null) {
      return null;
    }
    return File(chooseImage.path);
  }

  Future _saveNoticia(String titulo, String descripcion, String autor,
      String fuente, String imageUrl) async {
    await FirebaseFirestore.instance.collection("noticias").doc().set({
      "titulo": titulo,
      "descripcion": descripcion,
      "autor": autor,
      "fuente": fuente,
      "imagen": imageUrl,
      "fecha": DateTime.now().toString()
    });
  }

  Future<String> _uploadPicture(File image) async {
    String imagePath = image.path;
    // referencia al storage de firebase
    StorageReference reference = FirebaseStorage.instance
        .ref()
        .child("noticias/${Path.basename(imagePath)}");

    // subir el archivo a firebase
    StorageUploadTask uploadTask = reference.putFile(image);
    await uploadTask.onComplete;

    // recuperar la url del archivo que acabamos de subir
    dynamic imageURL = await reference.getDownloadURL();
    return imageURL;
  }
}
