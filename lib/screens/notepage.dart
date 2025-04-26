import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task6/db_notes/initdb.dart';
import 'package:task6/responsivesize/responsivedesign.dart';

class NotePage extends StatefulWidget{
  NotePage({super.key});
  State<NotePage> createState() => _NotePageState();
}
class _NotePageState extends State<NotePage>{
  List<String> allfilespathes=[
  "assets/images/file1.png",
  "assets/images/file2.png",
  "assets/images/file3.png",
  "assets/images/file4.png",
  "assets/images/file5.png",
  ];
  List<Map<String, dynamic>> ? allnotes ;
  InitDataBase db=InitDataBase();
  getdata({bool is_setstate=true}) async{
    allnotes =await db.getRecordsByIds(table: "notes",
    ids: [_args['id']]
    );
    if(is_setstate){
    setState(() {
      
    });
    }
  }
  TextEditingController _notenamecontroller=TextEditingController();
  late Map _args;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _args=ModalRoute.of(context)!.settings.arguments! as Map;
      getdata();
      
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    double screenwidth = MediaQuery.of(context).size.width;
    double screenheight = MediaQuery.of(context).size.width;
    StdFontSize fontsize = StdFontSize(screenwidth: screenwidth);
    return Scaffold(
            appBar: AppBar(
        backgroundColor: Color.fromRGBO(175, 219, 255, 1),
        title: Text(
          'Notes',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: fontsize.large,
          ),
        ),
      ),
      body:(allnotes == null)?Center(child: 
      CircularProgressIndicator(),): Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            child: GridView.builder(
              itemCount: allnotes!.length,
              gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: screenwidth / 20,
                mainAxisSpacing: 50,
                childAspectRatio: 1
            )
            , itemBuilder:(context,index){
            return 
              InkWell(
              onLongPress: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return StatefulBuilder(
                                        builder: (BuildContext context, void Function(void Function()) setState) {
                                        return Center(
                                          child: Material(
                                              child: Container(
                                              width: screenwidth /1.2,
                                              height: screenheight,
                                              decoration: BoxDecoration(
                                                color: Colors.white
                                              ),
                                                child: Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    
                                                    Row(
                                                      mainAxisSize: MainAxisSize.max,
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Container(
                                                          width: screenwidth/2,
                                                          child: TextField(
                                                            controller:
                                                                _notenamecontroller,
                                                            decoration: InputDecoration(
                                                              hintText:
                                                                  "Enter note name",
                                                              enabledBorder:
                                                                  OutlineInputBorder(
                                                                    borderRadius:
                                                                        BorderRadius.all(
                                                                          Radius.circular(
                                                                            20,
                                                                          ),
                                                                        ),
                                                                    borderSide: BorderSide(
                                                                      width: 2,
                                                                      color:
                                                                          Color.fromARGB(
                                                                            255,
                                                                            63,
                                                                            154,
                                                                            228,
                                                                          ),
                                                                    ),
                                                                  ),
                                                            ),
                                                          ),
                                                        ),
                                                        ElevatedButton(
                                                          onPressed: () {
                                                            db.updateNote(query: "UPDATE notes SET notename=? WHERE id=?",updated: [_notenamecontroller.text,allnotes![index]['id']]);
                                                            getdata();
                                                            Navigator.pop(context);
                                                            setState((){});
                                                          },
                                                          child: Text("Rename"),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 20,
                                                    ),
                                                    ElevatedButton(
                                                      onPressed: () {
                                                        db.deletedata(
                                                          query:
                                                              "DELETE FROM notes WHERE id=${allnotes![index]["id"]}",
                                                        );
                                                        getdata();
                                                        Navigator.pop(context);
                                                        setState(() {});
                                                      },
                                                      child: Text("Delete"),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                          ),
                                        );
                                        },
                                      );
                                    },
                                  );
                                },
                onTap: () async{
                  Navigator.of(context).pushNamed('/main/notes/mynote',arguments: allnotes![index]);
                },
                child: Container(
                  child: Column(
                    children: [
                      SizedBox(
                        height: screenheight/3,
                        child: Image.asset(allnotes![index]['filestylepath'])),
                        Text(
                            allnotes![index]["notename"],
                            style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: fontsize.large,
                            ),
                              ),
                    ],
                    
                  )
                  ),
              );
            }),
          ),
          Align(
            alignment: Alignment(0.8, 0.9),
            child: Container(
              child: FloatingActionButton(onPressed: (){
                 showDialog(
                            context: context,
                            builder: (context) {
                              int selectedfile = 0;
                              return StatefulBuilder(
                                builder: (
                                  BuildContext context,
                                  void Function(void Function()) setState,
                                ) {
                                  return Center(
                                    child: Material(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                        width: screenwidth / 1.5,
                                        height: screenheight / 1,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "Select note style",
                                              style: GoogleFonts.poppins(
                                                color: Colors.black,
                                                fontSize: fontsize.medium,
                                                fontWeight: FontWeight.w500,
                                                decoration: TextDecoration.none,
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.symmetric(
                                                vertical: 10,
                                              ),
                                              width: double.infinity,
                                              height: 50,
                                              child: ListView.builder(
                                                itemCount:
                                                    allfilespathes.length,
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemBuilder: (context, index) {
                                                  return InkWell(
                                                    onTap: () {
                                                      selectedfile = index;
                                                      setState(() {
                                                      });
                                                    },
                                                    child: Container(
                                                      padding: EdgeInsets.all(
                                                        5,
                                                      ),
                                                      color:
                                                          (selectedfile ==
                                                                  index)
                                                              ? Colors.grey[300]
                                                              : Colors.white,
                                                      margin:
                                                          EdgeInsets.symmetric(
                                                            horizontal: 3,
                                                          ),
                                                      child: Image.asset(
                                                        allfilespathes[index],
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.symmetric(
                                                horizontal: 5,
                                                vertical: 15,
                                              ),
                                              child: TextField(
                                                maxLength: 20,
                                                controller:
                                                    _notenamecontroller,
                                                decoration: InputDecoration(
                                                  hintText: "Enter folder name",
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                              Radius.circular(
                                                                20,
                                                              ),
                                                            ),
                                                        borderSide: BorderSide(
                                                          width: 2,
                                                          color: Color.fromARGB(
                                                            255,
                                                            63,
                                                            154,
                                                            228,
                                                          ),
                                                        ),
                                                      ),
                                                ),
                                              ),
                                            ),
                                            ElevatedButton(
                                              onPressed: () {
                                                db.insertdata(
                                                  table: "notes",
                                                  data: {
                                                    "notename":
                                                        _notenamecontroller
                                                            .text,
                                                    "filestylepath":
                                                        allfilespathes[selectedfile],
                                                    "folderid": _args['id'],
                                                  },
                                                );
                                                Navigator.pop(context);
                                                getdata();
                                              },
                                              child: Text(
                                                "create",
                                                style: GoogleFonts.aBeeZee(
                                                  color: Colors.white,
                                                  fontSize: fontsize.medium,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.blue,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          );
                        
              },
              child: Icon(Icons.add),
              backgroundColor: Color.fromRGBO(68, 161, 238, 1),
                          enableFeedback: true,
                          hoverElevation: 20,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
              ),
            ),
          ),
        ],
      ),
    );
  }

}