import 'dart:convert';
import 'dart:io';

import 'package:confere/components/constants.dart';
import 'package:confere/models/product.dart';
import 'package:confere/screens/product_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddProductsPage extends StatefulWidget {
  TextEditingController _nameController, _percentController;
  MoneyMaskedTextController _priceController, _saleController;

  AddProductsPage({Key key}) : super(key: key) {
    _nameController = TextEditingController();
    _priceController = MoneyMaskedTextController(decimalSeparator: '.', thousandSeparator: ',');
    _saleController = MoneyMaskedTextController(decimalSeparator: '.', thousandSeparator: ',');
    _percentController = TextEditingController();
  }

  @override
  _AddProductsPageState createState() => _AddProductsPageState();
}

class _AddProductsPageState extends State<AddProductsPage> {
  String _nameValue;
  String _priceValue;
  String _saleValue;
  String _percentValue;
  File _image;
  bool _available = false;

  bool isNameInvalid = false;
  bool isPriceInvalid = false;
  bool isSaleInvalid = false;
  String saleError;
  String priceError;
  var imagePicker;
  int groupValue = -1;

  @override
  void initState() {
    super.initState();
    imagePicker = new ImagePicker();
    widget._percentController.addListener(_calculateDiscount);
    widget._priceController.addListener(_updateFields);
  }

  @override
  void dispose() {
    widget._percentController.dispose();
    widget._priceController.dispose();
    widget._saleController.dispose();
    super.dispose();
  }

  void _calculateDiscount() {
    if(widget._percentController.text.isNotEmpty){
      try{
        var percent = double.parse(widget._percentController.text);
        var price = double.parse(widget._priceController.text);
        var salePrice = percent/100 * price;
        if(percent>=0 && percent<=100){
          widget._saleController.updateValue(price - salePrice);
        } else {
          if(percent<0){
            widget._saleController.updateValue(price);
          } else {
            widget._saleController.updateValue(0);
          }
        }
      } catch(e) {}
    } else {
      widget._saleController.updateValue(0);
    }
  }

  void _updateFields() {
    setState(() {
      widget._saleController.updateValue(0);
      widget._percentController.clear();
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Adicionar produto'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _imgFromGallery(),
        tooltip: 'Adicionar Imagem',
        child: Icon(Icons.attachment_outlined),
        backgroundColor: Color(0xff0267C1),
      ),
      body: Builder(
        builder: (context) => ListView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        children: [ 
          Column(
            children: [
              _image != null
              ? GestureDetector(
                onTap: () => null,
                child: Image.file(
                  _image,
                  width: MediaQuery.of(context).size.width,
                  height: 200,
                  fit: BoxFit.fitWidth,
                ),)
              : Container(
                height: 200,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.image), 
                    Text('Imagem')
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(right: 20, left: 20, top: 10),
                child: TextField(
                  controller: widget._nameController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: 'Nome',
                    hintText: 'Ex: Nike SB',
                    errorText: isNameInvalid ? 'Nome não pode ser vazio' : null,
                  ),
                ),
              ),
              Row(
                children: [
                  Flexible(
                    child: Container(
                      padding: EdgeInsets.only(right: 20, left: 20, top: 10),
                      child: TextField(
                        controller: widget._priceController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Preço',
                          prefix: Text('R\$ '),
                          errorText: isPriceInvalid ? priceError : null,
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    child: Container(
                      padding: EdgeInsets.only(right: 20, top: 10),
                      child: TextField(
                        controller: widget._percentController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: '% de desconto',
                          suffix: Text('% '),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Flexible(
                    child: Container(
                      padding: EdgeInsets.only(right: 20, left: 20, top: 10),
                      child: TextField(
                        controller: widget._saleController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Preço promoção',
                          prefix: Text('R\$ '),
                          errorText: isSaleInvalid ? saleError : null,
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    child: ListTile(
                      contentPadding: EdgeInsets.only(right: 20, top: 10),
                      title: Text('Disponível para venda'),
                      leading: Radio(
                        value: 1,
                        groupValue: groupValue,
                        toggleable: true,
                        onChanged: (value) {
                          setState(() {
                            groupValue = value;
                            _available = !_available;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                height: 50,
                margin: EdgeInsets.only(left: 50, top: 40, right: 50),
                child: MaterialButton(
                  onPressed: () => _onSubmit(),
                  color: Color(0xffD65108),
                  textColor: Colors.white,
                  child: Text('Adicionar Produto'),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
              ),
            ],
          ),
        ]
      ),
      ),
    );
  }

  _imgFromGallery() async {
    XFile image = await imagePicker.pickImage(
      source: ImageSource.gallery
    );

    setState(() {
      _image = File(image.path);
    });
  }

  void _onSubmit() {
    _nameValue = widget._nameController.text;
    _priceValue = widget._priceController.text;
    _saleValue = widget._saleController.text;
    _percentValue = widget._percentController.text;

    verifyNameValue();
    verifyPriceValue();
    verifySaleValue();

    if (!isNameInvalid && !isPriceInvalid && !isSaleInvalid){
      _addProduct();
    }
  }

  void verifyNameValue() {
    if (_nameValue.isEmpty){
      setState(() {      
        isNameInvalid = true;
      });
    } else {
      setState(() {      
        isNameInvalid = false;
      });
    }
  }

  void verifyPriceValue() {
    if (_priceValue.isEmpty){
      setState(() {    
        isPriceInvalid = true;
        priceError = 'Preço não pode ser vazio';
      });
    } else {
      setState(() {      
        isPriceInvalid = false;
      });
    }
  }

  void verifySaleValue() {
    if (_saleValue.isNotEmpty) {
      if (double.parse(_saleValue) > double.parse(_priceValue)){
        setState(() {
          isSaleInvalid = true;
          saleError = 'Promoção não pode ser maior que o preço';
        });
      } else {
        setState(() {        
          isSaleInvalid = false;
        });
      }
    }
  }

  void _addProduct() async {
    Product newProduct = new Product(
      image: _image != null ? _image.path : null,
      name: _nameValue,
      price: double.parse(_priceValue),
      salePrice: _saleValue.isNotEmpty ? double.parse(_saleValue) : null,
      percentDiscount: _percentValue.isNotEmpty ? double.parse(_percentValue) : null,
      onSale: _available,
    );
    // if(_saleValue.isNotEmpty){

    //   newProduct.percentDiscount = _percentValue.isNotEmpty ? double.parse(_percentValue) : null;
    // }

    _saveProduct(newProduct);
    _showSuccessDialog();
  }

  void _saveProduct(Product product) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var productsList = [];

    if(prefs.containsKey(productsDB)){
      String productsJson = prefs.getString(productsDB);
      Map<String, dynamic> productsMap = json.decode(productsJson);
      productsList = productsMap['products'];
    }

    productsList.add(product);
    
    Map<String, dynamic> newProductsMap = {
      'products': productsList
    };

    prefs.setString(
      productsDB, 
      json.encode(newProductsMap),
    );
  }

  void _showSuccessDialog() {
    var snackBar = SnackBar(content: Text('Produto adicionado com sucesso!'));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => ProductList()),
      (Route<dynamic> route) => false
    );
  }
}