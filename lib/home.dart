import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_tflite/flutter_tflite.dart';
class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _loading = true;
  File ?_image;
  List ?_output;
  final picker = ImagePicker();

   @override
   void initState(){
     super.initState();
     loadModel().then((value){
       setState(() {

       });
       });
   }

  detectImage(File image) async{
    var output = await Tflite.runModelOnImage(
      path: image.path,
      numResults:2,
      threshold:0.6,
      imageMean:127.5,
      imageStd:127.5
    );
    setState(() {
      _output = output;
      _loading = false;
    });
  }
  loadModel() async{
    await Tflite.loadModel(model:'assets/model_unquant.tflite',labels:'assets/labels.txt');
  }
  @override
  void dispose(){
     super.dispose();
  }
  pickImage()async{
     var image = await picker.getImage(source: ImageSource.camera);
         if(image == null)return null;

         setState(() {
           _image = File(image.path);
         });
         detectImage(_image!);
  }
  pickGalleryImage()async{
    var image = await picker.getImage(source: ImageSource.gallery);
    if(image == null)return null;

    setState(() {
      _image = File(image.path);
    });
    detectImage(_image!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 50,),
            Text('Coding Cafe',style: TextStyle(color: Colors.white,fontSize: 20),
            ),
            SizedBox(
              height: 5,),
            Text('Cats and Dogs Detector App',
            style: TextStyle(color: Colors.white,
            fontWeight: FontWeight.w500,fontSize: 30),
            ),
            SizedBox(
              height: 50,
            ),
            Center(
              child: _loading ? Container(
                width: 250,
                child: Column(
                  children: [
                    Image.asset('assets/cat_dog_icon.png'),
                    SizedBox(height: 50,)
                  ],
                ),
              ) : Container(
                child: Column(
                  children: [
                    Container(
                      height: 250,
                      child: Image.file(_image!),
                    ),SizedBox(
                      height: 20,

                    ),
                    _output !=null? Text('${_output?[0]['label']}',
                      style: TextStyle(color: Colors.white,
                          fontSize: 15),
                    )
                        :Container(),
                    SizedBox(
                      height: 10,
                    )
                  ],
                ),
              ) ,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              child: Column(children: [
                GestureDetector(onTap:(){
                  pickImage();
                },
                child: Container(
                  width: MediaQuery.of(context).size.width*250,
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(horizontal: 25,vertical: 18),
                decoration:BoxDecoration(
                    color: Colors.yellowAccent,
                    borderRadius: BorderRadius.circular(6)
                ),
                  child: Text('Capture Photo',
                    style: TextStyle(color: Colors.black45,fontSize: 16),
                  ),
                ),
                ),
                SizedBox(
                  height: 15,
                ),
                  GestureDetector(onTap:(){
                    pickGalleryImage();
                  },
                    child: Container(
                      width: MediaQuery.of(context).size.width*250,
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(horizontal: 25,vertical: 18),
                      decoration:BoxDecoration(
                          color: Colors.yellowAccent,
                          borderRadius: BorderRadius.circular(6)
                      ),
                      child: Text('Select Photo',
                        style: TextStyle(color: Colors.black45,fontSize: 16),
                      ),
                    ),
                  ),
              ],),
            )
          ],
        ),
    ),
    );
  }
}
