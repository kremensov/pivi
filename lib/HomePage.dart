import 'dart:io';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String result = "";
  File image;
  ImagePicker imagePicker = ImagePicker();

  captureFromGallery() async{
    PickedFile pickedFile = await imagePicker.getImage(source: ImageSource.gallery,
    maxWidth: 1800,
    maxHeight: 1800);
    if (pickedFile != null) {
      image = File(pickedFile.path);

    }


    setState(() {
      image;

      //Extraindo texto da imagem
      textFromImage();
    });

  }

  captureFromCamera() async{
    PickedFile pickedFile = await imagePicker.getImage(source: ImageSource.camera);
    image = File(pickedFile.path);
    result = "";
    setState(() {
      image;

      //Extraindo texto da imagem
      textFromImage();
    });

  }

  textFromImage() async{
    final FirebaseVisionImage firebaseVisionImage = FirebaseVisionImage.fromFile(image);
    final TextRecognizer recognizer = FirebaseVision.instance.textRecognizer();

    VisionText visionText = await recognizer.processImage(firebaseVisionImage);

    result = "";

    setState(() {
      for(TextBlock block in visionText.blocks){
        final String txt = block.text;
        for(TextLine line in block.lines){
          for(TextElement element in line.elements){
            result += element.text + " ";
          }
        }
        result += "\n\n";

      }
    });
  }

  @override
  void initState(){
    super.initState();
    imagePicker = ImagePicker();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.png'),
              fit: BoxFit.cover),
        ),
        child: Column(
          children: [
            SizedBox(width: 100.0),


            //Resultado do Container
            Container(
              height: 380.0,
                width: 320.0,
              margin: EdgeInsets.only(top: 70.0),
              padding: EdgeInsets.only(left: 28.0,bottom: 5.0, right: 18.0),
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Text(
                    result,
                    style: TextStyle(fontSize: 16.0),
                    textAlign: TextAlign.justify,
                  ),
                ),
              ),

              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/note.jpg'), fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20.0,right: 140.0),
              child: Stack(
                children: [
                  Stack(
                    children: [
                      Center(
                        child: Image.asset('assets/images/pin2.png',
                          height: 240.0,
                          width: 200.0,
                        ),
                      ),
                    ],
                  ),
                  Center(
                    child: TextButton(
                      onPressed: (){
                        captureFromCamera();
                      },
                      onLongPress: (){
                        captureFromGallery();
                      },
                      child: Container(
                        margin: EdgeInsets.only(top: 25.0),
                        child: image != null
                            ? Image.file(image,
                            width: 140.0,height: 192.0,fit: BoxFit.fill)
                            : Container(
                          width: 240.0,
                            height: 200.0,
                            child: Icon(
                              Icons.camera_alt,
                              size: 100.0,
                              color: Colors.indigo,
                            ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}