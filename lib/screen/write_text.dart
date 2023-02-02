import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:language_picker/languages.dart';
import 'package:translate_application/data_base/history/history_data_file.dart';
// import 'package:translate_application/data_base/book_mark/data_base_file.dart';
import 'package:translate_application/data_base/history/history_db_model.dart';
import 'package:translate_application/screen/first_page.dart';
import 'package:translate_application/screen/model_class/api_model.dart';
import 'package:translate_application/screen/translate_page.dart';
import 'package:translate_application/main.dart';

//Store history.........

// List<String> save_history=pref.getStringList('save_h') ?? [];
// List<String> savefavoritie=pref.getStringList('bookmark') ?? [];

class write_text extends StatefulWidget {
  Language selectedDialogLanguageleft, selectedDialogLanguageright;

  bool w_page;
  bool t_page;

  write_text(
      {required this.selectedDialogLanguageleft,
      required this.selectedDialogLanguageright,
      required this.w_page,
      required this.t_page});

  @override
  State<write_text> createState() => _write_textState();
}

class _write_textState extends State<write_text> {
  TextEditingController textcontroller = TextEditingController();

  //translate

  String arabicans = "";
  List answerlist = [];
  List<String> string = [];
  Translate? answer;

  Future<String> createAlbum(String title) async {
    print("${widget.selectedDialogLanguageright.isoCode}");
    print(textcontroller.text);
    final response = await http.get(
      Uri.parse(
          'https://translate.googleapis.com/translate_a/single?client=gtx&dt=t&dt=bd&dj=1&dt=ex&dt=ld&dt=md&dt=qca&dt=rw&dt=rm&dt=ss&dt=at&sl=${widget.selectedDialogLanguageleft.isoCode}&tl=${widget.selectedDialogLanguageright.isoCode}&q=${textcontroller.text.replaceAll(".", "")}'),
      // body: jsonEncode(<String, String>{
      //   'title': title,
      // }),
    );
    print("====${response.body}=============");
    if (response.statusCode == 200) {
      print(response.body);
      answer = Translate.fromJson(jsonDecode(response.body)['sentences'][0]);
      return arabicans = answer!.trans.toString();
      print("+++++++++++++++++${arabicans}++++++++++++++++++++++");
      // answer = Translate.fromJson(jsonDecode(response.body)['sentences'][0]);
      setState(() {});
    } else {
      throw Exception('Failed.......');
    }
  }

  @override
  void initState() {
    super.initState();
    get_history();
  }

  get_history() async {
    s_history = await DB.gethistory();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leadingWidth: 35,
        backgroundColor: Colors.teal,
        automaticallyImplyLeading: false,
        centerTitle: false,
        leading: IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return first_page();
                },
              ));
            },
            icon: Icon(Icons.keyboard_backspace_rounded)),
        title: Text(
          "Translate",
          style: TextStyle(color: Colors.white, fontFamily: "Regular"),
        ),
        actions: [
          IconButton(
              onPressed: () {
                textcontroller.clear();
              },
              icon: Icon(Icons.close)),
          SizedBox(
            width: 10,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
              flex: 2,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Container(
                  color: Colors.white,
                  width: double.infinity,
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: TextField(
                      maxLines: 500000000000000000,
                      style: TextStyle(color: Colors.black, fontSize: 16),
                      controller: textcontroller,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Enter Text',
                        hintStyle: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                ),
              )),
          Container(
              height: 50,
              color: Colors.grey,
              child: Align(
                alignment: Alignment.topRight,
                child: TextButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            content: Text(
                                'Do you want to delete the entire recent translation history?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text('CANCEL'),
                              ),
                              TextButton(
                                onPressed: () {
                                  setState(() {});
                                  Navigator.pop(context);
                                },
                                child: Text('DELETE'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Text(
                      "Delete history",
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    )),
              )),
          Expanded(
            flex: 7,
            child: Container(
              color: Colors.white,
              child: ListView.builder(
                itemCount: s_history.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () {
                      print("${s_history[index].history_data}");

                      textcontroller.text =
                          s_history[index].history_data.toString();
                      setState(() {});
                    },
                    title: Text(s_history[index].history_data),
                    trailing: IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                content: Text(
                                    'Do you want to delete the entire recent translation history?'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text('CANCEL'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      DB.delete(s_history[index].id!);
                                      s_history.removeAt(index);
                                      Navigator.pop(context);
                                      setState(() {});
                                    },
                                    child: Text('DELETE'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        icon: Icon(Icons.delete)),
                  );
                },
              ),

              // child: ListView.builder(itemBuilder: (context, index) {
              //   return ListTile(
              //     title: ,
              //   );
              // },),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          InkWell(
            onTap: () async {
              String text = await createAlbum(textcontroller.text.toString());
              print(text);

              DB.save(H_data(history_data: textcontroller.text));

              // save_history.add(textcontroller.text);
              // pref.setStringList('save_h',save_history);
              // print("${save_history}");

              setState(() {});
              print("${widget.selectedDialogLanguageright}");
              print("${widget.w_page}");

              print("translatepage${widget.t_page}");
              print('first page====${widget.w_page}');
              widget.w_page == true
                  ? Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                      builder: (context) {
                        return first_page(
                          arabic: text,
                          textwrit: textcontroller.text,
                        );
                      },
                    ), (route) => false)
                  : Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => traslate(
                            textans: textcontroller.text,
                            arabicans: text,
                            ans_t: widget.t_page),
                      ),
                      (route) => false);
            },
            child: Container(
              margin: EdgeInsets.only(left: 15, right: 15),
              height: 50,
              decoration: BoxDecoration(
                  color: Colors.teal, borderRadius: BorderRadius.circular(8)),
              child: Center(
                child: Text(
                  "Translate",
                  style: TextStyle(
                      fontSize: 20,
                      fontFamily: "SemiBold",
                      color: Colors.white),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }
}

/*
SingleChildScrollView(
        child: InkWell(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Container(
            padding: EdgeInsets.only(top: 15),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(left: 15, right: 15),
                  padding: EdgeInsets.only(left: 15, right: 15, bottom: 15),
                  height: MediaQuery.of(context).size.height - 270,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  child: Stack(
                    children: [
                      TextField(
                        maxLines: 500000000000000000,
                        style: TextStyle(color: Colors.black, fontSize: 16),
                        controller: textcontroller,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Enter Text',
                          hintStyle: TextStyle(color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: () async {
                    String text = await createAlbum(textcontroller.text.toString());
                    print(text);

                    setState(() {});
                    print("${widget.selectedDialogLanguageright}");
                    print("${widget.w_page}");


                    print("translatepage${widget.t_page}");
                    print('first page====${widget.w_page}');
                  widget.w_page==true?Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                      builder: (context) {
                        return first_page(
                          arabic: text,
                          textwrit: textcontroller.text,

                        );
                      },
                    ), (route) => false):
                  // Navigator.push(context,MaterialPageRoute(builder: (context) {
                  //     return traslate(textans: textcontroller.text,arabicans:text,);
                  //   },));
                  Navigator.push(context,MaterialPageRoute(builder: (context) {
                    return traslate(textans: textcontroller.text, arabicans: text, ans_t:widget.t_page);
                  },));
                  //   Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) {
                  //     return traslate(textans: textcontroller.text, arabicans: text,ans_t: widget.t_page,);
                  //   },), (route) => false);
                   },

                  child: Container(
                    margin: EdgeInsets.only(left: 15, right: 15),
                    height: 50,
                    decoration: BoxDecoration(
                        color: Colors.teal,
                        borderRadius: BorderRadius.circular(8)),
                    child: Center(
                      child: Text(
                        "Translate",
                        style: TextStyle(
                            fontSize: 20,
                            fontFamily: "SemiBold",
                            color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
*
* */
/*
*  ListView.builder(itemCount: save_history.length,itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () {
                      print('${save_history[index]}');

                          Navigator.push(context,MaterialPageRoute(builder: (context) {
                            return first_page(s_h: save_history[index]);
                          },));
                    },
                    title: Text("${save_history[index]}"),
                    trailing: IconButton(onPressed: () {
                      showDialog(context: context, builder: (context) {
                        return  AlertDialog(

                          content: Text('Delete your list?'),

                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },             // function used to perform after pressing the button
                              child: Text('CANCEL'),
                            ),
                            TextButton(
                              onPressed: () {
                                save_history.removeAt(index);
                                pref.setStringList('save_h',save_history);
                                Navigator.pop(context);
                                setState(() {});
                              },
                              child: Text('DELETE'),
                            ),
                          ],
                        );
                      },);




                    }, icon:Icon(Icons.delete_sharp))
                  );
                },),
* */