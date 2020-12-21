import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:midtest/book.dart';
import 'package:midtest/bookdetail.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(

        body: Container(
          child: Mainscreen(),
        ),
      ),
    );
  }
}

class Mainscreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<Mainscreen> {
  List bookList;
  double screenHeight = 0.00;
  double screenWidth = 0.00;
  String titlecenter = "Loading Bookstore...";
  int starCount = 5;
  double rating = 0.00;

  @override
  void initState() {
    super.initState();
    _loadBookStore();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('List of Books'),
      ),
      body: Column(
        children: [
          bookList == null
              ? Flexible(
                  child: Container(
                      child: Center(
                          child: Text(titlecenter,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              )))))
              : Flexible(
                  child: GridView.count(
                  crossAxisCount: 2,
                  childAspectRatio: (screenWidth / screenHeight) / 0.8,
                  children: List.generate(bookList.length, (index) {
                    return Padding(
                      padding: EdgeInsets.all(1),
                      child: Card(
                        child: InkWell(
                         onTap: _loadBookDetail(index), 
                        child: Column(
                          children: [
                          Container(
                              height: screenHeight / 3.8,
                              width: screenWidth / 1.2,
                              child: CachedNetworkImage(
                                imageUrl:
                                    "http://slumberjer.com/bookdepo/bookcover/${bookList[index]['cover']}.jpg",
                                fit: BoxFit.cover,
                                placeholder: (context, url) =>
                                    new CircularProgressIndicator(),
                                errorWidget: (context, url, error) => new Icon(
                                  Icons.broken_image,
                                  size: screenWidth / 2,
                                ),
                              )),
                          SizedBox(height: 5),
                          Text(
                            bookList[index]['booktitle'],
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          ),
                           StarRating(
                           size: 14.5,
                           rating: double.parse(
                           bookList[index]['rating'],
                           ),
                          color: Colors.black,
                           borderColor: Colors.grey,
                           starCount: starCount,
                           onRatingChanged: (rating) => setState(
                            () {
                             this.rating = rating;
                            },
                            ),
                            ),
                          SizedBox(height: 5),
                          Text(
                            "Rating: " + bookList[index]['rating'],
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "Author: " + bookList[index]['author'],
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text("Price: RM " + bookList[index]['price'],
                              style: TextStyle(
                                fontSize: 15,
                          ))
                        ]),
          ),
                    ));
                  }),
              ))
        ],
      ),
    );
  }

  void _loadBookStore() {
    http.post("http://slumberjer.com/bookdepo/php/load_books.php", body: {
      "bookid": "2",
    }).then((res) {
      print(res.body);
      if (res.body == "nodata") {
        bookList = null;
        setState(() {
          titlecenter = "No Book Found";
        });
      } else {
        var jsondata = json.decode(res.body);
        bookList = jsondata["book"];
      }
    }).catchError((err) {
      print(err);
    });
  }

   _loadBookDetail(int index) {
    print(bookList[index]['booktitle']);
   // ignore: unused_local_variable
   Book book = new Book(
   bookid: bookList[index]['bookid'],
   booktitle: bookList[index]['booktitle'],
   author: bookList[index]['author'],
   price: bookList[index]['price'],
   descriptions: bookList[index]['description'],
   rating: bookList[index]['rating'],
   publisher: bookList[index]['publisher'],
   isbn: bookList[index]['isbn'],
   cover: bookList[index]['cover']);

   Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => BookDetails(
  
                )));

}
}

