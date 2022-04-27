import 'package:car_wash/constans.dart';
import 'package:car_wash/models/car_wash_model.dart';
import 'package:car_wash/provider/auth_provider.dart';
import 'package:car_wash/serviceLocator.dart';
import 'package:car_wash/size_config.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:car_wash/models/message_model.dart';

class WashReviews extends StatefulWidget {
  final Wash carWash;

  const WashReviews({Key? key, required this.carWash}) : super(key: key);

  @override
  _WashReviewsState createState() => _WashReviewsState();
}

class _WashReviewsState extends State<WashReviews> {
  @override
  Widget build(BuildContext context) {
    double rating = 3.0;
    final TextEditingController commentController = TextEditingController();
    final AuthProvider? _authProvider = serviceLocator<AuthProvider>();

    Future<List<MessageModel>?> getMessages() async {
      DocumentReference docRef = FirebaseFirestore.instance
          .collection('comments')
          .doc(widget.carWash.id);
      DocumentSnapshot? docSnap = await docRef.get();
      CommentsCarwashList? list = CommentsCarwashList.fromSnapshot(docSnap);
      return list.list;
    }

    return SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.4,
        child: Stack(
          fit: StackFit.expand,
          clipBehavior: Clip.hardEdge,
          children: [
            Positioned(
              bottom: 120,
              top: 0,
              left: 0,
              right: 0,
              child: FutureBuilder(
                future: getMessages(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<MessageModel>?> snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return snapshot.data != null
                        ? ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (BuildContext context, int index) {
                              return ListTile(
                                title: Text(
                                    '${snapshot.data![index].from!.displayName}'),
                                subtitle:
                                    Text('${snapshot.data![index].message}'),
                                trailing: RatingBar.builder(
                                  initialRating: snapshot.data![index].rating!,
                                  minRating: snapshot.data![index].rating!,
                                  maxRating: snapshot.data![index].rating!,
                                  direction: Axis.horizontal,
                                  allowHalfRating: true,
                                  itemCount: 5,
                                  itemSize: 25,
                                  itemPadding:
                                      EdgeInsets.symmetric(horizontal: 2.0),
                                  itemBuilder: (context, _) => Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                  ),
                                  onRatingUpdate: (rating) {
                                    print(rating);
                                  },
                                ),
                              );
                            })
                        : Container();
                  } else {
                    return Center(
                      child: CircularProgressIndicator(
                        color: kPrimaryColor,
                      ),
                    );
                  }
                },
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: RatingBar.builder(
                      initialRating: 3,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemSize: 40,
                      itemCount: 5,
                      itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                      itemBuilder: (context, _) => Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (value) {
                        rating = value;
                      },
                    ),
                  ),
                  Container(
                      width: double.infinity,
                      color: kPrimaryColor,
                      child: ListTile(
                        trailing: FlatButton(
                          onPressed: () {
                            _authProvider!
                                .comment(MessageModel(
                                    to: widget.carWash.id,
                                    from: _authProvider.currentUser,
                                    message: commentController.text,
                                    rating: rating,
                                    date: DateTime.now()))
                                .then((value) {
                              setState(() {});
                            });
                          },
                          child: Icon(Icons.send),
                        ),
                        title: TextFormField(
                          controller: commentController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Заполните поле";
                            }
                            return null;
                          },
                          style: TextStyle(
                              color: Color(0xFF030303),
                              fontWeight: FontWeight.w300),
                          decoration: InputDecoration(
                              hintText: "Enter comment",
                              hintStyle: TextStyle(
                                  color: Color(0x7C7C7C7C),
                                  fontSize: getProportionateScreenWidth(18),
                                  fontWeight: FontWeight.w300),
                              labelText: "comment",
                              labelStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: getProportionateScreenWidth(16),
                                  fontWeight: FontWeight.w300)),
                        ),
                      ))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
