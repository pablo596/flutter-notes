import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:notes/services/services.dart';

mostrarAlertaActions(
    BuildContext context, String titulo, String subtitulo, String uid) {
  final notasService = new NotasService();
  if (Platform.isAndroid) {
    return showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(titulo),
        content: Text(subtitulo),
        actions: <Widget>[
          MaterialButton(
            child: Text('Eliminar'),
            elevation: 5,
            textColor: Colors.redAccent,
            onPressed: () async {
              var delete = await notasService.deleteNote(uid).then((value) {
                Navigator.pop(context);
              });
            },
          ),
          MaterialButton(
            child: Text('Cancelar'),
            elevation: 5,
            textColor: Colors.blue,
            onPressed: () => Navigator.pop(context, 'cancel'),
          )
        ],
      ),
    );
  }

  showCupertinoDialog(
    context: context,
    builder: (_) => CupertinoAlertDialog(
      title: Text(titulo),
      content: Text(subtitulo),
      actions: <Widget>[
        CupertinoDialogAction(
          // isDefaultAction: true,
          isDestructiveAction: true,
          child: Text('Eliminar'),
          onPressed: () async {
            var delete = await notasService.deleteNote(uid).then((value) {
              Navigator.pop(context);
            });
          },
        ),
        CupertinoDialogAction(
          isDefaultAction: true,
          child: Text('Cancelar'),
          onPressed: () => Navigator.pop(context, 'cancel'),
        )
      ],
    ),
  );
}
