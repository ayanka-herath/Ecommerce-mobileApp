
//import 'package:first_project/models/login.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'Login.dart';
//import 'signup.dart';
import 'book.dart';
//import 'authentication.dart';
//import 'package:provider/provider.dart';

class BookfirebaseDemo extends StatefulWidget {
  static const routeName='/home';
  BookfirebaseDemo(): super();
  //Title
  final String appTitle = "Online Book Store";
  @override
  _BookfirebaseDemoState createState() => _BookfirebaseDemoState();
}
class _BookfirebaseDemoState extends State<BookfirebaseDemo> {
  TextEditingController bookNameController=TextEditingController();
  TextEditingController authorNameController=TextEditingController();
  TextEditingController quantityController=TextEditingController();
  TextEditingController priceController=TextEditingController();
  bool isEditing=false;
  bool textfieldVisibility=false;

  String fireStoreCollectionName="Book";
  Book curentBook;

  getAllBooks(){
    return Firestore.instance.collection(fireStoreCollectionName).snapshots();
  }

  addbook() async{
    Book book = Book(bookName: bookNameController.text, authorName: authorNameController.text, 
                quantity: quantityController.text,price: priceController.text);

    try{
        
                Firestore.instance.runTransaction((transaction) async{
          await Firestore.instance
                                  .collection(fireStoreCollectionName)
                                  .document()
                                  .setData(book.toJason());
                }
                );
    }
    catch(e)
    { 
      print(e.toString()); 
    }
  }

  updateBook(Book book,String bookName,String authorName,String quantity,String price)
  {
    
    try{
        
                Firestore.instance.runTransaction((Transaction transaction) async{
          await transaction.update(book.documentReference, {'bookName': bookName,'authorName':authorName,'quantity':quantity,'price':price});
                }
                );
    }
    catch(e)
    {
      print(e.toString()); 
    }
  }

  updatedIfEditing()
  {
    if(isEditing)
    {
      updateBook(curentBook, bookNameController.text, authorNameController.text,quantityController.text,priceController.text);
    }
    setState(() {
      isEditing=false;
    });
  }

  deleteBook(Book book)
  {
    Firestore.instance.runTransaction((Transaction transaction) async
    {
      await transaction.delete(book.documentReference);
    }
    );
  }

  Widget buildBody(BuildContext context)
  {
    return StreamBuilder<QuerySnapshot>(
      stream: getAllBooks(),
      builder: (context,snapshot){
        if(snapshot.hasError)
        {
          //To show error
          return Text('Error ${snapshot.error}');
        }
        if(snapshot.hasData)
        {
          print("Documents => ${snapshot.data.documents.length}");
          return buildList(context,snapshot.data.documents);
        }
        
      },
    );
  }

  Widget buildList(BuildContext context, List<DocumentSnapshot> snapshot)
  {
    return ListView(
      children: snapshot.map((data) =>listItemBuild(context,data)).toList(),
    );
  }

  Widget listItemBuild(BuildContext context,DocumentSnapshot data){
    final book= Book.fromSnapshot(data);
    return Padding(
      key: ValueKey(book.bookName),
      padding: EdgeInsets.symmetric(vertical: 19, horizontal: 1),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color:Colors.indigo),
          borderRadius: BorderRadius.circular(4)
        ),
         child: SingleChildScrollView(
           child: ListTile(
             title: Column(
               children: <Widget>[
                 Row(
                   children: <Widget>[
                 Icon(Icons.book, color: Colors.yellow,),
                 Text('BookName: '),
                 Text(book.bookName),
               ],
              ),
              Divider(),
              Row(
                children: <Widget>[
                  Icon(Icons.person,color:Colors.deepPurple),
                  Text('Author Name: '),
                  Text(book.authorName)
                ],
              ),
               Divider(),
              Row(
                children: <Widget>[
                  Icon(Icons.add_box,color:Colors.brown),
                  Text('Quantity: '),
                  Text(book.quantity)
                ],
              ),
               Divider(),
              Row(
                children: <Widget>[
                  Icon(Icons.money,color:Colors.green ),
                  Text('Price: '),
                  Text(book.price)
                ],
              )
               ],
           ),
          trailing: IconButton(
            icon:Icon(Icons.delete,color: Colors.red,),
            onPressed: () {
              deleteBook(book);
  
            } 
            ),
            onTap: (){
              setUpdateUI(book);
            },
         )
      ),
    ),
    );
  }

  setUpdateUI(Book book)
  {
    bookNameController.text=book.bookName;
    authorNameController.text=book.authorName;
    quantityController.text=book.quantity;
    priceController.text=book.price;
    setState(() {
      textfieldVisibility=true;
      isEditing=true;
      curentBook=book;
    });
  }

  button()
  {
    return SizedBox(
      
      width: double.infinity,
      child: RaisedButton(
        color:Colors.blueAccent,
        textColor: Colors.white,
        child:Text(
          isEditing ? "Update" : "Add"
        ),
        onPressed: (){
          if(isEditing==true)
          {
            updatedIfEditing();
          }
          else{
            addbook();
          }
          setState(() {
            textfieldVisibility=false;
          });
        },
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(widget.appTitle),
        actions: <Widget>[
          FlatButton(
            child: Row(
              children: <Widget>[
                Text('Logout'),
                Icon(Icons.person)
              ],
            ),
            textColor: Colors.white,
            onPressed: (){
              Navigator.of(context).pushReplacementNamed(Login.routeName);
            },
          ),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: (){
              setState(() {
                textfieldVisibility= !textfieldVisibility;
              });
            },
          )
        ],
      ),
      
    body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors:[
                Colors.cyan,
                Colors.blueAccent,

              ]
            )

          ),
      
      padding: EdgeInsets.all(19),
      child:Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
        ),
      child:Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          textfieldVisibility
          ? Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Column(
                children: [
                  TextFormField(
                    controller:bookNameController,
                    decoration:InputDecoration(
                      labelText:"Book Name",
                      hintText:"Enter Book Name"
                    )
                  ),
                TextFormField(
              controller:authorNameController,
              decoration:InputDecoration(
                labelText:"Author Name",
                hintText:"Enter Author Name"
              ),
                
              ),
            TextFormField(
                    controller:quantityController,
                    decoration:InputDecoration(
                      labelText:"Quantity",
                      hintText:"Enter quantity"
                    )
                  ),
            TextFormField(
                    controller:priceController,
                    decoration:InputDecoration(
                      labelText:"Price",
                      hintText:"Enter price"
                    )
                  ),
            ],
            ),
            SizedBox(
          height:10,
        ),
        button()
            ],
          ):Container(),
              SizedBox(
          height: 20,
        ),
          Text("BOOKS",style:TextStyle(
          fontSize: 18,
          fontWeight:FontWeight.w800,
        ),),
        SizedBox(
          height: 20,
        ),
        Flexible(child:buildBody(context),)
          
          
        
        ],
        )
      
      
    
      ),
    ),
    );
  }
}