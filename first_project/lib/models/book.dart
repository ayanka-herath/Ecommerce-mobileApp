import 'package:cloud_firestore/cloud_firestore.dart';
//Model file
class Book
{
  String bookName;
  String authorName;
  String quantity;
  String price;

  DocumentReference documentReference;
  
    //creating constructor
    Book({this.bookName,this.authorName,this.quantity,this.price});
    //create mapping
    Book.fromMap(Map<String,dynamic> map,{this.documentReference})
    {
      bookName = map["bookName"];
      authorName=map["authorName"];
      quantity = map["quantity"];
      price = map["price"];
    }
  //getting details from snapshot within documentreffer
    Book.fromSnapshot(DocumentSnapshot snapshot)
        :this.fromMap(snapshot.data, documentReference:snapshot.reference);
      //To convert it to jason
        toJason()
        {
          return{'bookName': bookName,'authorName': authorName, 'quantity': quantity, 'price': price};
        }
      }
    
    

  
 


