import 'package:flutter/material.dart';

class BookDetails extends StatefulWidget {
  @override
  _BookDetailsState createState() => _BookDetailsState();
}

class _BookDetailsState extends State<BookDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book Details'),
      ),
      body: Center(
        child: Container(
          child: Text('Details'),
        ),
      ),
    );
  }
}
