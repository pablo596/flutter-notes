import 'dart:async';

import 'package:flutter/material.dart';
import 'package:notes/helpers/helpers.dart';
import 'package:notes/models/models.dart';
import 'package:notes/screens/screens.dart';
import 'package:notes/services/services.dart';
import 'package:notes/widgets/widgets.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final notasService = new NotasService();

  List<Nota> notas = [];
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  // ignore: prefer_typing_uninitialized_variables
  var _height;
  var _width;

  @override
  void initState() {
    print('aqui');
    this._cargarNotas();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      print(timeStamp);
    });
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Timer.periodic(Duration(seconds: 10), (timer) {
        takeScreenshot();
      });
    });
    super.initState();
  }

  void takeScreenshot() {
    if (ModalRoute.of(context)!.isCurrent) {
      print('toma la foto');
      _cargarNotas();
    }
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    final notasService = Provider.of<NotasService>(context);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final resultado = await Navigator.pushNamed(context, 'note',
                  arguments: Nota(title: "", description: "", uid: ""))
              .then((value) {
            _cargarNotas();
          });
        },
        child: Icon(
          Icons.edit,
          color: Colors.white,
        ),
        backgroundColor: Colors.black,
      ),
      appBar: AppBar(
        backgroundColor: const Color(0xFFd9d9d9),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(50),
            bottomRight: Radius.circular(50),
          ),
        ),
        title: const Text('Notas'),
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
      body: SmartRefresher(
        controller: _refreshController,
        enablePullDown: true,
        onRefresh: _cargarNotas,
        header: WaterDropHeader(
          complete: Icon(
            Icons.check,
            color: Colors.blue[400],
          ),
          // waterDropColor: Colors.blue[400],
        ),
        child: _listItems(),
      ),
    );
    // body: _listItems());
  }

  Widget _listItems() {
    if (notas.isNotEmpty) {
      return GridView.builder(
        padding: const EdgeInsets.all(30),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 30,
          mainAxisSpacing: 30,
          childAspectRatio: MediaQuery.of(context).size.height * .00075,
        ),
        itemCount: notas.length,
        itemBuilder: (BuildContext context, int index) {
          return _noteItem(index);
        },
      );
    } else {
      return SingleChildScrollView(
        child: ClipRect(
          child: CustomPaint(
            size: Size(MediaQuery.of(context).size.width, 700),
            painter: ArrowPainter(),
          ),
        ),
      );
      // child: Center(
      //   child: Text('No hay notas creadas aún.'),
      // ),
    }
  }

  void _cargarNotas() async {
    notas = (await notasService.getNotas())!;
    setState(() {});

    // await Future.delayed(Duration(milliseconds: 1000));

    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  Widget _noteItem(int index) {
    final notaServiceNotify = Provider.of<NotasService>(context, listen: false);
    final authServiceNotify = Provider.of<AuthService>(context, listen: false);
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, 'note',
                arguments: Nota(
                    title: notas[index].title!,
                    description: notas[index].description!,
                    uid: notas[index].uid))
            .then((value) {
          _cargarNotas();
        });
      },
      child: Container(
        decoration: const BoxDecoration(
          color: Color(0xFFd9d9d9),
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        // height: 100,/
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                  onPressed: () async {
                    final result = await mostrarAlertaActions(
                        context,
                        'Eliminar nota:',
                        notas[index].title!,
                        notas[index].uid!);

                    final eliminacion = await notaServiceNotify.eliminacion;

                    _cargarNotas();
                  },
                  icon: const Icon(
                    Icons.delete,
                    size: 40,
                  )),
            ),
            Container(
              margin: const EdgeInsets.all(15),
              height: MediaQuery.of(context).size.height * .15,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      notas[index].title!,
                      style: const TextStyle(fontSize: 25),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Container(
                      // width: 100,
                      child: Text(
                        notas[index].description!,
                        style: const TextStyle(fontSize: 10),
                        softWrap: true,
                        maxLines: 5,
                        // textWidthBasis: TextWidthBasis.longestLine,
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
