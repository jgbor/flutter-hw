import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_homework/network/data_source_interceptor.dart';
import 'package:get_it/get_it.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

//DO NOT MODIFY
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureFixDependencies();
  await configureCustomDependencies();
  runApp(const MyApp());
}

//DO NOT MODIFY
Future configureFixDependencies() async {
  var dio = Dio();
  dio.interceptors.add(
    PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseHeader: true,
    ),
  );
  dio.interceptors.add(DataSourceInterceptor());
  GetIt.I.registerSingleton(dio);
  GetIt.I.registerSingleton(await SharedPreferences.getInstance());
  GetIt.I.registerSingleton(<NavigatorObserver>[]);
}

//Add custom dependencies if necessary
Future configureCustomDependencies() async {

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: MyHomePage(key: UniqueKey(), title: 'Flutter Demo'),
      //DO NOT MODIFY
      navigatorObservers: GetIt.I<List<NavigatorObserver>>(),
      //DO NOT MODIFY
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, this.title = ""}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Widget> _myColorWidgets = [
    RandomColorWidget(key: UniqueKey()),
    RandomColorWidget(key: UniqueKey())
  ];

  void _reverseList() {
    setState(() {
      var temp = _myColorWidgets[0];
      _myColorWidgets[0] = _myColorWidgets[1];
      _myColorWidgets[1] = temp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'My colored widgets: ',
            ),
            ..._myColorWidgets
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _reverseList,
        tooltip: 'Reverse',
        child: Icon(Icons.swap_vert),
      ),
    );
  }
}

class StatelessColorWidget extends StatelessWidget {
  final Color color;

  const StatelessColorWidget({Key? key, this.color = Colors.transparent})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      height: 40,
      color: color,
    );
  }
}

class RandomColorWidget extends StatefulWidget {
  const RandomColorWidget({Key? key}) : super(key: key);

  @override
  _RandomColorWidgetState createState() => _RandomColorWidgetState();
}

class _RandomColorWidgetState extends State<RandomColorWidget> {
  late Color currentColor;

  @override
  void initState() {
    var rnd = Random();
    currentColor =
        Color.fromRGBO(rnd.nextInt(256), rnd.nextInt(256), rnd.nextInt(256), 1);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StatelessColorWidget(
      color: currentColor,
    );
  }
}
