import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:confere/models/product.dart';
import 'package:confere/screens/addProduct.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductList extends StatefulWidget {
  @override
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Stack(
            children: [
              Container(
                height: 170,
              ),
              Container(
                alignment: Alignment.center,
                height: 150.0,
                width: MediaQuery.of(context).size.width,
                decoration: new BoxDecoration(
                  color: Color(0xff0075C4),
                  shape: BoxShape.rectangle,
                  borderRadius: new BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
                ),
                child: Text(
                  'Gerenciador de produtos',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                child: Container(
                  height: 40,
                  width: 350,
                  margin: EdgeInsets.only(left: 20, right: 20),
                  child: TextField(
                    controller: null,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      hintText: 'Buscar',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(
                          width: 0,
                          style: BorderStyle.none,
                        ),
                      ),
                      filled: true,
                      contentPadding: EdgeInsets.only(top: 20),
                      fillColor: Colors.grey[200]
                    ),
                  ),
                ),
              ),
            ],
          ),
          FutureBuilder(
            future: SharedPreferences.getInstance(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                
                if (!snapshot.data.containsKey('PRODUCTS_DB')) {
                  return Expanded(
                    child: Container(
                      child: Center(
                        child: Text(
                          "Nenhum produto cadastrado",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xff9E9D9D),
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )
                  );
                
                } else {
                  var productsJson = snapshot.data.getString('PRODUCTS_DB');
                  Map<String, dynamic> productsMap = json.decode(productsJson);
                  var productsList = productsMap['products'];
                  List<Product> teste = [];
                  for(var product in productsList){
                    teste.add(new Product.fromJson(product));
                  }
                  teste.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
                  return Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: teste.length,
                      itemBuilder: (BuildContext context, int index) {
                        if(teste.length <= 0) {
                          return Expanded(
                            child: Container(
                              child: Center(
                                child: Text(
                                  "Nenhum produto cadastrado",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Color(0xff9E9D9D),
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            )
                          );
                        } else {
                          return Container(
                            margin: EdgeInsets.only(bottom: 10),
                            child:  
                          Slidable(
                            key: ValueKey(0),
                            startActionPane: ActionPane(
                              motion: ScrollMotion(),
                              dismissible: DismissiblePane(onDismissed: () {}),
                              children: [
                                SlidableAction(
                                  onPressed: null,
                                  backgroundColor: Color(0xFFFE4A49),
                                  foregroundColor: Colors.white,
                                  icon: Icons.delete,
                                  label: 'Delete',
                                ),
                              ],
                            ),
                            child: Container(
                              height: 130.0,
                              decoration: new BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.rectangle,
                                border: Border.all(color: Colors.grey[100]),
                                boxShadow: <BoxShadow>[
                                  new BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 10.0,
                                    offset: new Offset(0.0, 10.0),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(left: 10, top: 10, bottom: 10),
                                    width: 130,
                                    child: teste[index].image != null ?
                                    Image.file(
                                      File(teste[index].image),
                                      fit: BoxFit.fill,
                                    )
                                  :
                                    Stack(
                                      children: [
                                        Container(color: Colors.grey[100]),
                                        Align(
                                          alignment: Alignment.center,
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Icon(Icons.image), 
                                              Text('Imagem')
                                            ],
                                          ),
                                        ),
                                      ],
                                    )
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: 10, left: 5, bottom: 10),
                                    child: Column(
                                      children: [
                                        Text(
                                          teste[index].name.toUpperCase(),
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ));
                        }
                      }
                    ),
                  );
                }

              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            }
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddProductScreen,
        tooltip: 'Adicionar Produto',
        child: Icon(Icons.add),
        backgroundColor: Color(0xff0267C1),
      ),
    );
  }
  
  void _openAddProductScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddProductsPage()),
    ).then(onGoBack);
  }

  FutureOr onGoBack(dynamic value) {
    // refreshData();
    setState(() {});
  }

}