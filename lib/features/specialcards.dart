import 'package:flutter/material.dart';

class Special extends StatelessWidget {
  final String texto;
  final Widget destino;
  const Special({super.key, required this.texto, required this.destino});

  @override
  Widget build(BuildContext context) {
    return Card(
      child:
      TextButton
      (
      child: Text(texto),
           onPressed: () 
           {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => destino),
            );
           },
      ),
    );
  }
}