import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task6/db_notes/initdb.dart';
import 'package:task6/responsivesize/responsivedesign.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  TextEditingController _foldernamecontroller = TextEditingController();
  List<String> allfolderspaths = [
    'assets/images/folder1.png',
    'assets/images/folder2.png',
    'assets/images/folder3.png',
    'assets/images/folder4.png',
    'assets/images/folder5.png',
    'assets/images/folder6.png',
    'assets/images/folder7.png',
  ];
  List<Map<String, dynamic>>? foldersdata;
  InitDataBase db = InitDataBase();
  @override
  void initState() {
    getdata();
    // TODO: implement initState
    super.initState();
  }

  getdata() async {
    foldersdata = await db.getAlldata(table: "folders");
    setState(() {});
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
      backgroundColor: Colors.grey[200],
      body:
          (foldersdata == null)
              ? Center(child: CircularProgressIndicator())
              : Stack(
                children: [
                  Flex(
                    direction: Axis.vertical,
                    children: [
                      Expanded(
                        child: Container(
                          child: GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: screenwidth / 20,
                                  mainAxisSpacing: 50,
                                ),
                            itemCount: foldersdata!.length,
                            itemBuilder: (context, index) {
                              return InkWell(
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
                                                                _foldernamecontroller,
                                                            decoration: InputDecoration(
                                                              hintText:
                                                                  "Enter folder name",
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
                                                            db.updateNote(query: "UPDATE folders SET foldername=? WHERE id=?",updated: [_foldernamecontroller.text,foldersdata![index]['id']]);
                                                            getdata();
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
                                                              "DELETE FROM folders WHERE id=${foldersdata![index]["id"]}",
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
                                onTap: () {
                                  Navigator.pushNamed(context, '/main/notes',arguments:foldersdata![index]);
                                },
                                child: Container(
                                  padding: EdgeInsets.all(8),
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: screenheight / 4,
                                        child: Image.asset(
                                          foldersdata![index]["foldershapepath"],
                                        ),
                                      ),
                                      Text(
                                        foldersdata![index]["foldername"],
                                        style: GoogleFonts.poppins(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500,
                                          fontSize: fontsize.large,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  Align(
                    alignment: Alignment(0.8, 0.9),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(68, 161, 238, 1),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: FloatingActionButton(
                        backgroundColor: Color.fromRGBO(68, 161, 238, 1),
                        enableFeedback: true,
                        hoverElevation: 20,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              int selectedfolder = 0;
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
                                              "Select folder style",
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
                                                    allfolderspaths.length,
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemBuilder: (context, index) {
                                                  return InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        selectedfolder = index;
                                                      });
                                                    },
                                                    child: Container(
                                                      padding: EdgeInsets.all(
                                                        5,
                                                      ),
                                                      color:
                                                          (selectedfolder ==
                                                                  index)
                                                              ? Colors.grey[300]
                                                              : Colors.white,
                                                      margin:
                                                          EdgeInsets.symmetric(
                                                            horizontal: 3,
                                                          ),
                                                      child: Image.asset(
                                                        allfolderspaths[index],
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
                                                controller:
                                                    _foldernamecontroller,
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
                                                  table: "folders",
                                                  data: {
                                                    "foldername":
                                                        _foldernamecontroller
                                                            .text,
                                                    "foldershapepath":
                                                        allfolderspaths[selectedfolder],
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
                      ),
                    ),
                  ),
                ],
              ),
    );
  }
}
