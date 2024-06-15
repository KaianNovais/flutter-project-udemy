import 'package:api_consumo_flutter_movies/screen/home_page.dart';
import 'package:api_consumo_flutter_movies/services/filme_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context)=> ApiService(),
      child:  MaterialApp(
        debugShowCheckedModeBanner: false,
        home: TelaPrincipal(),
      ),
    );
  }
}