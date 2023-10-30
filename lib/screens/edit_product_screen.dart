import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../providers/products.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>(); //our form's key
  var _editedProduct =
      Product(price: 0, imageUrl: '', id: '', title: '', description: '');
  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': '',
  };
  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit == true) {
      Object? productId = ModalRoute.of(context)?.settings.arguments;
      if (productId != null) {
        _editedProduct = Provider.of<Products>(context, listen: false)
            .findById(productId.toString());
        _initValues = {
          'title': _editedProduct.title,
          'description': _editedProduct.description,
          'price': _editedProduct.price.toString(),
          // 'imageUrl': _editedProduct.imageUrl,
          'imageUrl': '',
        };
        _imageUrlController.text = _editedProduct.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    //DISPOSING SO NO MEMORY LEAK OCCURS
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  void _updateImageUrl() {
    //CHECKING IF IMAGE IS VALID BEFORE LOADING IT
    if (!_imageUrlFocusNode.hasFocus) {
      if ((!_imageUrlController.toString().startsWith('http') &&
              !_imageUrlController.toString().startsWith('https')) ||
          (!_imageUrlController.toString().endsWith('.jpg') &&
              !_imageUrlController.toString().endsWith('.png') &&
              !_imageUrlController.toString().endsWith('.jpeg'))) {
        return;
      }
      setState(() {});
    }
  }

  void _saveForm() {
    final _isValid = _form.currentState?.validate();
    if (_isValid != true) {
      return;
    }
    _form.currentState?.save(); //please dont forget putting this before using
//.save() will save the progress we did in form, which was overriding _editedProduct
    setState(() {
      _isLoading = true;
    });
    if (!_editedProduct.id.isEmpty) {
      Provider.of<Products>(context, listen: false)
          .updateProduct(_editedProduct.id, _editedProduct);
    } else {
      Provider.of<Products>(context, listen: false)
          .addProduct(_editedProduct)
          .then((_) {
//Waiting for data to register in backend before going back to user_products_screen
        setState(() {
          _isLoading = true;
        });
        Navigator.of(context).pop();
      });
    }

    // Navigator.of(context).pop();//moved up so we wait until the adding is done
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit / Add product'),
        actions: [
          IconButton(onPressed: _saveForm, icon: const Icon(Icons.save))
        ],
      ),
      body: _isLoading //Wait for the data fetching from back end
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(10),
              child: Form(
                key: _form,
                child: ListView(
                  children: [
                    TextFormField(
                      // textAlign: TextAlign.right,

                      decoration: InputDecoration(
                        labelText: 'Title',
                      ),
                      initialValue: _initValues['title'],
                      validator: (value) {
                        //returning null means input is correct, if you return a text
                        //it will be treated as the error text
                        if (value.toString().isEmpty) {
                          return 'Please enter a title';
                        } else {
                          return null;
                        }
                      },
                      textInputAction: TextInputAction
                          .next, //determines what pressing enter does
                      onSaved: (value) {
                        _editedProduct = Product(
                            price: _editedProduct.price,
                            imageUrl: _editedProduct.imageUrl,
                            id: _editedProduct.id,
                            isFavorite: _editedProduct.isFavorite,
                            title: value.toString(),
                            description: _editedProduct.description);
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['price'],
                      decoration: InputDecoration(
                        labelText: 'Price',
                      ),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value.toString().isEmpty) {
                          return 'Please enter a price.';
                        }
                        if (double.tryParse(value.toString()) == null) {
                          return 'Please enter a valid number.';
                        }
                        if (double.parse(value.toString()) <= 0) {
                          return 'Please enter a valid number.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                            price: double.parse(value.toString()),
                            imageUrl: _editedProduct.imageUrl,
                            id: _editedProduct.id,
                            title: _editedProduct.title,
                            isFavorite: _editedProduct.isFavorite,
                            description: _editedProduct.description);
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['description'],
                      decoration: InputDecoration(
                        labelText: 'Description',
                      ),
                      // textInputAction: TextInputAction.next, //we're in multiline.
                      validator: (value) {
                        if (value.toString().isEmpty) {
                          return 'Please enter a description';
                        }
                        if (value.toString().length < 10) {
                          return 'Should be at least 10 characters long.';
                        } else {
                          return null;
                        }
                      },
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      onSaved: (value) {
                        _editedProduct = Product(
                            price: _editedProduct.price,
                            imageUrl: _editedProduct.imageUrl,
                            id: _editedProduct.id,
                            isFavorite: _editedProduct.isFavorite,
                            title: _editedProduct.title,
                            description: value.toString());
                      },
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          margin: EdgeInsets.only(top: 8, right: 10, left: 3),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                              width: 1,
                              color: Colors.grey,
                            ),
                          ),
                          child: _imageUrlController.text.isEmpty
                              ? Text('Enter a URL')
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(5),
                                  child: Image.network(
                                    _imageUrlController.text,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                        ),
                        Expanded(
                            child: TextFormField(
                          // initialValue: _initValues['imageURL'],
                          decoration: InputDecoration(labelText: 'Image URL'),
                          keyboardType: TextInputType.url,
                          validator: (value) {
                            if (value.toString().isEmpty) {
                              return 'Please enter an image URL';
                            }
                            if (!value.toString().startsWith('http') &&
                                !value.toString().startsWith('https')) {
                              return 'Please enter a valid link';
                            }
                            if (value.toString().endsWith('.jpg') &&
                                value.toString().endsWith('.png') &&
                                value.toString().endsWith('.jpeg')) {
                              return 'Please enter a valid image URL';
                            } else {
                              return null;
                            }
                          },
                          textInputAction: TextInputAction.done,
                          controller: _imageUrlController,
                          focusNode: _imageUrlFocusNode,
                          onEditingComplete: () {
                            setState(() {});
                          },
                          onSaved: (value) {
                            _editedProduct = Product(
                                price: _editedProduct.price,
                                imageUrl: value.toString(),
                                id: _editedProduct.id,
                                title: _editedProduct.title,
                                isFavorite: _editedProduct.isFavorite,
                                description: _editedProduct.description);
                          },
                          onFieldSubmitted: (_) {
                            _saveForm();
                            // FocusScope.of(context).unfocus();
                            FocusManager.instance.primaryFocus
                                ?.unfocus(); //null safety unfocus
                          },
                        )),
                      ],
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
