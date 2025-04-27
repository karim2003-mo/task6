import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:task6/db_notes/initdb.dart';
import 'package:task6/responsivesize/responsivedesign.dart';

class MyNote extends StatefulWidget {
  MyNote({super.key});
  State<MyNote> createState() => _MyNoteState();
}

class _MyNoteState extends State<MyNote>{
  final ImagePicker picker = ImagePicker();
  Uint8List ? imageBytes;
  File? pickedImage;
  InitDataBase _db=InitDataBase();
  Map<String, dynamic> ? note;
  late TextEditingController _titlecontroller;
  late TextEditingController _notecontroller;

    getdata({bool is_setstate=true , required int id}) async{
    List allnotes =await _db.getAlldata(table: "notes");
    note=allnotes.firstWhere((element) => element['id']==id); // Move getdata call here
    if(is_setstate){
    setState(() {
    _titlecontroller.text=note!['title']??"";
    _notecontroller.text=note!['note']??"";
    });
    }
  }
  Future<void> pickImageFromGallery() async {
  final XFile? image = await picker.pickImage(source: ImageSource.gallery);
  
  if (image != null) {
    pickedImage = File(image.path);
    // Update UI or process the image
    imageBytes=await pickedImage!.readAsBytes();
  }
  setState(() {
  });
}
  Future<void> _captureImage() async {
    try {
      final image = await picker.pickImage(source:ImageSource.camera);
      if (image != null) {
        pickedImage=File(image.path);
          imageBytes=await pickedImage!.readAsBytes();
        setState(() {
        });// Use the image file here
        print('Image captured: ${image.path}');
      }
    } catch (e) {
      print('Error capturing image: $e');
    }
  }


late Map args;
@override
void initState() {
  super.initState();
  _titlecontroller=TextEditingController();
  _notecontroller=TextEditingController();
  WidgetsBinding.instance.addPostFrameCallback((_) {
    args = ModalRoute.of(context)!.settings.arguments! as Map;
    getdata(is_setstate: true, id: args['id']);
  });
}
  @override
  Widget build(BuildContext context) {
    double screenwidth = MediaQuery.of(context).size.width;
    double screenheight = MediaQuery.of(context).size.height;
    StdFontSize fontsize = StdFontSize(screenwidth: screenwidth);
    print(screenheight);
    return Scaffold(
        appBar: AppBar(
        backgroundColor: Color.fromRGBO(175, 219, 255, 1),
        title: Text(
          note?['notename']??"......",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: fontsize.large,
          ),
        ),
      ),
      body: Padding(padding:EdgeInsets.only(top: 50,right: 5,left: 5),
        child:(note!=null)? SingleChildScrollView(
          child: Container(
            height: screenheight,
            child: Stack(
              children: [
                Align(alignment: Alignment.topRight,
                child: ElevatedButton(onPressed: () async{
                  // ignore: unused_local_variable
                  final res=await _db.updateNote(query:'UPDATE notes SET image = ? , title = ? , note = ? WHERE notename = ?',
                  updated: [imageBytes??note!['image'],_titlecontroller.text,_notecontroller.text,args['notename']]
                  );
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    duration: Duration(seconds: 2), // 2 seconds
                    behavior: SnackBarBehavior.floating, // Makes it float above content
                    content: Text("contet has been saved successfully")));
                }, child: Text("Save")),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child:(pickedImage==null&&note!['image']==null)? InkWell(
                    onTap: (){
                      dialouge(context);
                    },
                    child: DottedBorder(
                              color: Colors.blue,
                              strokeWidth: 2,
                              borderType: BorderType.RRect,
                              radius: Radius.circular(10),
                              dashPattern: [6, 3],
                              child: Container(
                                width: 150,
                                height: 150,
                                alignment: Alignment.center,
                                child:Container(width:30,
                                height: 30,
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(50)
                                ),
                                child: Icon(Icons.add),
                                )
                              ),
                            ),
                  ):(note!['image']==null||pickedImage!=null)?InkWell(
                    onLongPress: (){
                      dialouge(context);
                    },
          
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth:screenwidth/2),
                      child: Container(
                        height: screenheight/4,
                        child: Image.file(pickedImage!,fit: BoxFit.fill,)),
                    ),
                  ):
                    InkWell(
                      onLongPress: (){
                        dialouge(context);
                      },
                      child: ConstrainedBox(
                        constraints: BoxConstraints(maxWidth:screenwidth/2),
                        child: Container(
                        height:screenheight/4 ,
                        child: Image.memory(note!['image'],fit: BoxFit.fill,)),
                      ),
                    )
                ),
                Align(
                  alignment: Alignment(0.9, -0.8),
                  child: Container(
                    width: screenwidth/2.5,
                    child: TextField(
                      textInputAction: TextInputAction.done,
                      controller: _titlecontroller,
                      style: TextStyle(
                        fontSize: fontsize.medium,
                        fontWeight: FontWeight.w600
                      ),
                        maxLines: null,
                        maxLength: 100, // Allows unlimited lines
                        decoration: InputDecoration(
                        enabledBorder: InputBorder.none,
                        border:InputBorder.none ,
                        hintText: "Add Tittle",
                        hintStyle: TextStyle(
                          color: Colors.grey[400]
                        ),
                      ),
                    ),
                  ),
                ),Align(
                  alignment: Alignment(0, 0.2),
                  child: Container(
                    width: double.infinity,
                    height: screenheight/2,
                    child:TextField(
                      textInputAction: TextInputAction.done,
                      maxLines: null,
                      controller: _notecontroller,
                        decoration: InputDecoration(
                        enabledBorder: InputBorder.none,
                        border:InputBorder.none ,
                        hintText: "Add Note",
                        hintStyle: TextStyle(
                          color: Colors.grey[400]
                        ),
                      ),
                    ) ,
                  ),
                )
              ],
            ),
          ),
        ):Center(child:CircularProgressIndicator()),
      ),
    );
  }
dialouge(BuildContext context){
  showDialog(context: context, builder:
                    (context){
                      return Center(
                        child: Material(
                          child: Container(
                            decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(width: 1,
                            color: Colors.blue
                            )
                            ),
                            width: 200,
                            height: 200,
                            child:Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                InkWell(
                                  onTap: (){
                                    pickImageFromGallery();
                                    Navigator.pop(context);
                                  },
                                child: Container(
                                  child:SizedBox(width: 70,height: 70,
                                  child: Image.asset("assets/images/gallery.png"),
                                  )
                                ),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                                InkWell(
                                  onTap: () {
                                    _captureImage();
                                    Navigator.pop(context);
                                  },
                                child: Container(
                                  padding: EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Color.fromRGBO(199, 3, 65, 1)
                                  ),
                                  child:SizedBox(
                                  child: Icon(Icons.camera_alt_outlined,size: 40,color: Colors.white,),
                                  )
                                ),
                              )
                              ],
                            ) ,
                          ),
                        ),
                      );
                    }
                    );
                                    
}
  @override
  void dispose() {
    super.dispose();
  }
}