import 'package:flutter/material.dart';
import 'package:notes/models/models.dart';
import 'package:notes/services/services.dart';

// class ScreenArguments {
//   final String title;
//   final String description;
//   final String uid;

//   ScreenArguments(this.title, this.description);
// }

class NoteViewScreen extends StatelessWidget {
  const NoteViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Nota;

    TextEditingController _titleController = new TextEditingController();
    TextEditingController _descriptionController = new TextEditingController();
    if (args.title!.isNotEmpty) {
      _titleController.text = args.title!;
      _descriptionController.text = args.description!;
    }
    final notasService = new NotasService();

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () async {
          if (args.uid!.isEmpty) {
            var nota = await notasService.newNote(
                _titleController.text, _descriptionController.text);
          } else {
            var nota = await notasService.updateNote(
                _titleController.text, _descriptionController.text, args.uid!);
          }
          Navigator.pop(context, 'Datos que quieres pasar');
        },
        child: const Icon(
          Icons.save,
          color: Colors.white,
        ),
      ),
      appBar: AppBar(
        backgroundColor: const Color(0xFFd9d9d9),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(50),
            bottomRight: Radius.circular(50),
          ),
        ),
        title: TextField(
          textCapitalization: TextCapitalization.sentences,
          decoration: const InputDecoration(hintText: 'Nueva nota'),
          controller: _titleController,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 30),
            child: ClipOval(
              child: Material(
                color: Colors.black, // Button color
                child: InkWell(
                  splashColor: Colors.white54, // Splash color
                  onTap: () => Navigator.pushNamed(context, 'profile'),
                  child: const Icon(
                    Icons.person,
                    color: Color(0xFFd9d9d9),
                    size: 32.5,
                  ),
                  // SizedBox(width: 56, height: 56, child: Icon(Icons.person)),
                ),
              ),
            ),
          )
        ],
      ),
      body: Scrollbar(
        thickness: 5, //width of scrollbar
        radius: const Radius.circular(20), //corner radius of scrollbar
        scrollbarOrientation:
            ScrollbarOrientation.right, //which side to show scrollbar
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              controller: _descriptionController,
              maxLines: 200,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                  hintText: 'Escribe aquí el cuerpo de la nota.'),
            ),
          ),
        ),
      ),
    );
  }
}
