import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:language_picker/language_picker.dart';
import 'package:language_picker/language_picker_dropdown.dart';
import 'package:language_picker/languages.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:text_to_speech/text_to_speech.dart';
import 'package:translate_application/data_base/book_mark/data_base_file.dart';
import 'package:translate_application/screen/bookmark.dart';
import 'package:translate_application/screen/first_page.dart';
import 'package:translate_application/screen/model_class/api_model.dart';
import 'package:translate_application/screen/write_text.dart';
import 'package:translate_application/main.dart';
import 'package:translate_application/data_base/book_mark/dbmodel.dart';
import 'package:http/http.dart' as http;
import 'package:translate_application/screen/zoom_out_screen.dart';

import 'package:flutter/material.dart';

import 'package:flutter/cupertino.dart';

import 'package:language_picker/languages.dart';
import 'package:language_picker/language_picker.dart';

Language selectedDialogLanguage_tl = Language.fromIsoCode(select_lanuage_l);
Language selectedDialogLanguager_tr = Language.fromIsoCode(select_lanuage_r);

String select_lanuage_l = pref.getString('select_l_l') ?? "en";

String select_lanuage_r = pref.getString('select_l_r') ?? "gu";

// final prefs = SharedPreferences.getInstance();
// List<String> savefavoritie=pref.getStringList('bookmark') ?? [];
// List<String> save_history=pref.getStringList('save_h') ?? [];

class traslate extends StatefulWidget {
  String textans, arabicans;
  bool ans_t;

  traslate({
    required this.textans,
    required this.arabicans,
    required this.ans_t,
  });

  @override
  State<traslate> createState() => _traslateState();
}

class _traslateState extends State<traslate> {
  // TextEditingController textcontroler=TextEditingController();

  bool trans_p = false;
  bool ans_t = false;

  //clear
  bool close = false;

  //faveritoes
  bool startap = false;

  //MIC
  SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = '';
  String secoundspeack = '';

  TextToSpeech tts = TextToSpeech();

  //Storedata favorities...............

  Translate? answer;
  String arabicans = "";

  Future<String> createAlbum(String title) async {
    // print("${selectedDialogLanguagel.isoCode}");
    final response = await http.get(
      Uri.parse(
          'https://translate.googleapis.com/translate_a/single?client=gtx&dt=t&dt=bd&dj=1&dt=ex&dt=ld&dt=md&dt=qca&dt=rw&dt=rm&dt=ss&dt=at&sl=${selectedDialogLanguage_tl.isoCode}&tl=${selectedDialogLanguager_tr.isoCode}&q=${widget.arabicans}'),
    );
    print("====${response.body}=============");
    if (response.statusCode == 200) {
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
    _initSpeech();
    setState(() {});

    // close=widget.ans_t;
  }

  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  void _startListening() async {
    setState(() {});
    await _speechToText.listen(onResult: _onSpeechResult);
  }

  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      widget.textans = result.recognizedWords;
      // secoundspeack = result.recognizedWords;
    });
  }

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
                flex: 1,
                child: Container(
                  color: Colors.teal,
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                          color: Colors.teal,
                          child: LanguagePickerDropdown(
                            initialValue: swap_language
                                ? selectedDialogLanguager_tr
                                : selectedDialogLanguage_tl,
                            onValuePicked: (Language language) => setState(() {
                              selectedDialogLanguage_tl = language;
                              String sl =
                                  selectedDialogLanguage_tl.isoCode.toString();
                              pref.setString('select_l_l', sl);
                              select_lanuage_l = sl;
                              print(selectedDialogLanguager_tr.name);
                              print(selectedDialogLanguage_tl.isoCode);
                            }),
                            itemBuilder: buildDialogItem,
                          ),
                        ),
                      ),
                      Align(
                        child: InkWell(
                            child: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                              color: Colors.teal, shape: BoxShape.circle),
                          child: IconButton(
                              onPressed: () {
                                setState(() {
                                  print("i am swap value");
                                  swap_language = !swap_language;
                                  print(swap_language);
                                  Navigator.pushAndRemoveUntil(context,
                                      MaterialPageRoute(
                                    builder: (context) {
                                      return traslate(
                                          textans: widget.textans,
                                          arabicans: arabicans,
                                          ans_t: ans_t);
                                    },
                                  ), (route) => false);
                                });

                                setState(() {});
                              },
                              icon: Icon(
                                Icons.swap_horiz_outlined,
                                size: 25,
                                color: Colors.white,
                              )),
                        )),
                      ),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                          height: double.infinity,
                          color: Colors.teal,
                          child: LanguagePickerDropdown(
                            initialValue: swap_language
                                ? selectedDialogLanguage_tl
                                : selectedDialogLanguager_tr,
                            onValuePicked: (Language language) => setState(
                              () {
                                selectedDialogLanguager_tr = language;
                                String sr = selectedDialogLanguager_tr.isoCode
                                    .toString();
                                pref.setString('select_l_r', sr);
                                select_lanuage_r = sr;
                                print(selectedDialogLanguager_tr.name);
                                print(selectedDialogLanguager_tr.isoCode);
                              },
                            ),
                            itemBuilder: buildDialogItem,
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
            Expanded(
                flex: 8,
                child: InkWell(
                  onTap: () {
                    trans_p = true;
                    print("====translate ${trans_p}=====");
                    widget.ans_t = false;
                    print("++++anshwer+++++++++++=${widget.ans_t}");

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return write_text(
                            selectedDialogLanguageleft:
                                selectedDialogLanguage_tl,
                            selectedDialogLanguageright:
                                selectedDialogLanguager_tr,
                            w_page: false,
                            t_page: true,
                          );
                        },
                      ),
                    );
                  },
                  child: widget.ans_t == true
                      ? Container(
                          color: Colors.white,
                          child: Column(
                            children: [
                              Expanded(
                                  flex: 2,
                                  child: Container(
                                    // height: double.infinity,
                                    color: Colors.white,
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  12, 0, 0, 0),
                                              child: IconButton(
                                                  onPressed: () {
                                                    tts.speak(widget.textans
                                                        .toString());
                                                    tts.setVolume(15);
                                                    tts.getVoice();
                                                  },
                                                  icon: Icon(
                                                    Icons.volume_up_outlined,
                                                    color: Colors.grey,
                                                    size: 35,
                                                  )),
                                            ),
                                            //SizedBox(width: 290,),
                                            Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  0, 12, 0, 0),
                                              child: IconButton(
                                                  onPressed: () {
                                                    widget.textans = "";
                                                    setState(() {});
                                                  },
                                                  icon: Icon(
                                                    Icons.close,
                                                    color: Colors.grey,
                                                    size: 35,
                                                  )),
                                            ),
                                          ],
                                        ),
                                        // Padding(
                                        //   padding: EdgeInsets.all(10),
                                        //   child: SingleChildScrollView(
                                        //     scrollDirection: Axis.vertical,
                                        //     child: Container(
                                        //       height: 200,
                                        //       child: Text(
                                        //         "${widget.textans}",
                                        //         style: TextStyle(
                                        //             color: Colors.black,
                                        //             fontSize: 20),
                                        //       ),
                                        //     ),
                                        //   ),
                                        // ),

                                        Expanded(
                                          child: SingleChildScrollView(
                                            scrollDirection: Axis.vertical,
                                            child: Container(
                                              // color: Colors.red,
                                              child: Padding(
                                                padding: EdgeInsets.all(10),
                                                child: Text(
                                                  "${widget.textans}",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 20),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )),
                              Divider(),
                              Expanded(
                                flex: 6,
                                child: Container(
                                  color: Colors.white,
                                  child: Stack(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          IconButton(
                                              onPressed: () {
                                                tts.speak(widget.arabicans
                                                    .toString());
                                                tts.setVolume(15);
                                                tts.getVoice();
                                              },
                                              icon: Icon(
                                                Icons.volume_up_outlined,
                                                size: 35,
                                                color: Colors.grey,
                                              )),
                                          IconButton(
                                              onPressed: () async {
                                                DB.save(Data(
                                                    save_bookmark: widget
                                                        .textans
                                                        .toString()));

                                                // savefavoritie.add(widget.textans);
                                                // pref.setStringList('bookmark',savefavoritie);
                                                //
                                                // print(savefavoritie);
                                                // print("======${savefavoritie}========");

                                                // await prefs.setString('action', '${widget.textans}');

                                                setState(() {
                                                  startap = true;
                                                  print(
                                                      "starttap==${startap}==");
                                                });

                                                Fluttertoast.showToast(
                                                    msg: "Added to favorities",
                                                    toastLength:
                                                        Toast.LENGTH_SHORT,
                                                    gravity:
                                                        ToastGravity.BOTTOM,
                                                    timeInSecForIosWeb: 1,
                                                    backgroundColor:
                                                        Colors.black26,
                                                    textColor: Colors.white,
                                                    fontSize: 16.0);
                                              },
                                              icon: startap == true
                                                  ? IconButton(
                                                      onPressed: () {
                                                        // savefavoritie.remove(widget.textans);
                                                        // pref.setStringList('bookmark',savefavoritie);

                                                        setState(() {});
                                                        startap = false;
                                                        startap == false
                                                            ? Icon(Icons
                                                                .star_border)
                                                            : Icon(Icons.star);
                                                      },
                                                      icon: Icon(Icons.star))
                                                  : Icon(
                                                      Icons.star_border,
                                                      size: 35,
                                                      color: Colors.grey,
                                                    )),
                                          IconButton(
                                              onPressed: () async {
                                                await Clipboard.setData(
                                                    ClipboardData(
                                                        text:
                                                            widget.arabicans));
                                                Fluttertoast.showToast(
                                                    msg: "Text Copied",
                                                    toastLength:
                                                        Toast.LENGTH_SHORT,
                                                    gravity:
                                                        ToastGravity.BOTTOM,
                                                    timeInSecForIosWeb: 1,
                                                    backgroundColor:
                                                        Colors.black26,
                                                    textColor: Colors.white,
                                                    fontSize: 16.0);
                                              },
                                              icon: Icon(
                                                Icons.copy_outlined,
                                                size: 35,
                                                color: Colors.grey,
                                              )),
                                          IconButton(
                                              onPressed: () {
                                                Share.share(
                                                    sharePositionOrigin:
                                                        Rect.fromLTWH(
                                                            1, 1, h, h / 3),
                                                    widget.arabicans);
                                              },
                                              icon: Icon(
                                                Icons.share,
                                                size: 35,
                                                color: Colors.grey,
                                              )),
                                          IconButton(
                                              onPressed: () {
                                                Navigator.push(context,
                                                    MaterialPageRoute(
                                                  builder: (context) {
                                                    return zoom_out_screen(
                                                      zoom_out_value:
                                                          widget.arabicans,
                                                    );
                                                  },
                                                ));
                                              },
                                              icon: Icon(
                                                Icons.zoom_in_map,
                                                size: 35,
                                                color: Colors.grey,
                                              )),
                                        ],
                                      ),
                                      // widget.textans!=null?Align(alignment: Alignment.center,child: Text("${store_mic}",style: TextStyle(fontSize: 35,color: Colors.teal),)):Align(alignment: Alignment.center,child: Text("${widget.arabicans}",style: TextStyle(fontSize: 30,color: Colors.black),)),
                                      Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(10, 70, 10, 10),
                                        child: Text(
                                          textAlign: TextAlign.center,
                                          "${widget.arabicans}",
                                          style: TextStyle(
                                              color: Colors.teal, fontSize: 25),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(15, 0, 0, 20),
                                        child: Align(
                                          alignment: Alignment.bottomLeft,
                                          child: IconButton(
                                              onPressed: () {
                                                print("Dropdown menu");
                                                showModalBottomSheet(
                                                  context: context,
                                                  builder: (context) {
                                                    return SizedBox(
                                                      height: 200,
                                                      child: Column(
                                                        children: [
                                                          ListTile(
                                                            onTap: () {
                                                              Navigator
                                                                  .pushReplacement(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                builder:
                                                                    (context) {
                                                                  return first_page();
                                                                },
                                                              ));
                                                            },
                                                            leading: Icon(
                                                              Icons.translate,
                                                              color:
                                                                  Colors.teal,
                                                            ),
                                                            title: Text(
                                                              "interpret",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black),
                                                            ),
                                                            trailing: Text(
                                                              "shared view",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .grey),
                                                            ),
                                                          ),
                                                          ListTile(
                                                            onTap: () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            leading: Icon(
                                                              Icons.chat,
                                                              color:
                                                                  Colors.teal,
                                                            ),
                                                            title: Text(
                                                              "translate",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black),
                                                            ),
                                                            trailing: Text(
                                                              "solo view",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .grey),
                                                            ),
                                                          ),
                                                          ListTile(
                                                            onTap: () {
                                                              Navigator
                                                                  .pushReplacement(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                builder:
                                                                    (context) {
                                                                  return bookmark();
                                                                },
                                                              ));
                                                            },
                                                            leading: Icon(
                                                              Icons.star_border,
                                                              color:
                                                                  Colors.teal,
                                                            ),
                                                            title: Text(
                                                              "favorites",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                );
                                              },
                                              icon: Icon(
                                                Icons.dehaze_rounded,
                                                color: Colors.grey,
                                                size: 35,
                                              )),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(0, 0, 0, 20),
                                        child: Align(
                                          alignment: Alignment.bottomCenter,
                                          child: InkWell(
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  color: Colors.teal,
                                                  shape: BoxShape.circle),
                                              height: 60,
                                              width: 60,
                                              child: Center(
                                                  child: IconButton(
                                                      onPressed: () async {
                                                        if (_speechToText
                                                                .isListening ==
                                                            true) {
                                                          print(
                                                              "++++CALLING API FUNCTION++++++++");
                                                          print(
                                                              "listening is false");
                                                          print(_speechToText
                                                              .isNotListening);
                                                          widget.arabicans =
                                                              widget.textans
                                                                  .toString();
                                                          print(store_mic);
                                                          widget.arabicans =
                                                              await createAlbum(
                                                                  widget
                                                                      .arabicans
                                                                      .toString());
                                                          print(
                                                              "ANSHWER==${store_mic}");
                                                          setState(() {});
                                                        } else {
                                                          print(
                                                              "listening is satartr");
                                                          print(_speechToText
                                                              .isListening);
                                                        }

                                                        //print("Helo");
                                                        setState(() {});
                                                        _speechToText
                                                                .isNotListening
                                                            ? _startListening()
                                                            : _stopListening();
                                                        print(_speechToText
                                                            .isNotListening);
                                                      },
                                                      icon: _speechToText
                                                              .isNotListening
                                                          ? Icon(
                                                              Icons
                                                                  .mic_off_rounded,
                                                              color:
                                                                  Colors.white,
                                                            )
                                                          : Icon(
                                                              Icons.mic,
                                                              color: Colors.red,
                                                            ))

                                                  // Icon(
                                                  //   _speechToText.isNotListening
                                                  //       ? Icons.mic_off
                                                  //       : Icons.mic,
                                                  //   size: 30,
                                                  //   color: Colors.white,
                                                  // ),
                                                  ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : Container(
                          color: Colors.white,
                          child: Stack(
                            children: [
                              // Container(
                              //   height: 40,
                              //   child: Text("${widget.textans}",style: TextStyle(fontSize: 25,color: Colors.black),),
                              // ),
                              // Divider(),
                              Padding(
                                padding: EdgeInsets.all(10),
                                child: Text(
                                  "Tap to enter text.",
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 25),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(15, 0, 0, 20),
                                child: Align(
                                  alignment: Alignment.bottomLeft,
                                  child: IconButton(
                                      onPressed: () {
                                        print("Dropdown menu");
                                        showModalBottomSheet(
                                          context: context,
                                          builder: (context) {
                                            return SizedBox(
                                              height: 200,
                                              child: Column(
                                                children: [
                                                  ListTile(
                                                    onTap: () {
                                                      Navigator.pushReplacement(
                                                          context,
                                                          MaterialPageRoute(
                                                        builder: (context) {
                                                          return first_page();
                                                        },
                                                      ));
                                                    },
                                                    leading: Icon(
                                                      Icons.translate,
                                                      color: Colors.teal,
                                                    ),
                                                    title: Text(
                                                      "interpret",
                                                      style: TextStyle(
                                                          color: Colors.black),
                                                    ),
                                                    trailing: Text(
                                                      "shared view",
                                                      style: TextStyle(
                                                          color: Colors.grey),
                                                    ),
                                                  ),
                                                  ListTile(
                                                    onTap: () {
                                                      Navigator.pop(context);
                                                    },
                                                    leading: Icon(
                                                      Icons.chat,
                                                      color: Colors.teal,
                                                    ),
                                                    title: Text(
                                                      "translate",
                                                      style: TextStyle(
                                                          color: Colors.black),
                                                    ),
                                                    trailing: Text(
                                                      "solo view",
                                                      style: TextStyle(
                                                          color: Colors.grey),
                                                    ),
                                                  ),
                                                  ListTile(
                                                    onTap: () {
                                                      Navigator.pushReplacement(
                                                          context,
                                                          MaterialPageRoute(
                                                        builder: (context) {
                                                          return bookmark();
                                                        },
                                                      ));
                                                    },
                                                    leading: Icon(
                                                      Icons.star_border,
                                                      color: Colors.teal,
                                                    ),
                                                    title: Text(
                                                      "favorites",
                                                      style: TextStyle(
                                                          color: Colors.black),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        );
                                      },
                                      icon: Icon(
                                        Icons.dehaze_rounded,
                                        color: Colors.grey,
                                        size: 35,
                                      )),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
                                child: Align(
                                  alignment: Alignment.bottomCenter,
                                  child: InkWell(
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.teal,
                                          shape: BoxShape.circle),
                                      height: 60,
                                      width: 60,
                                      child: Center(
                                          child: IconButton(
                                              onPressed: () async {
                                                if (_speechToText.isListening ==
                                                    true) {
                                                  print(
                                                      "++++CALLING API FUNCTION++++++++");
                                                  print("listening is false");
                                                  print(_speechToText
                                                      .isNotListening);
                                                  store_mic = widget.arabicans
                                                      .toString();
                                                  print(store_mic);
                                                  store_mic = await createAlbum(
                                                      store_mic.toString());
                                                  print(
                                                      "ANSHWER==${store_mic}");
                                                  setState(() {});
                                                } else {
                                                  print("listening is satartr");
                                                  print(_speechToText
                                                      .isListening);
                                                }

                                                print("Helo");
                                                setState(() {});
                                                _speechToText.isNotListening
                                                    ? _startListening()
                                                    : _stopListening();
                                                print(_speechToText
                                                    .isNotListening);
                                              },
                                              icon: _speechToText.isNotListening
                                                  ? Icon(
                                                      Icons.mic_off_rounded,
                                                      color: Colors.white,
                                                    )
                                                  : Icon(
                                                      Icons.mic,
                                                      color: Colors.red,
                                                    ))

                                          // Icon(
                                          //   _speechToText.isNotListening
                                          //       ? Icons.mic_off
                                          //       : Icons.mic,
                                          //   size: 30,
                                          //   color: Colors.white,
                                          // ),
                                          ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                ))
          ],
        ),
      ),
    );
  }
}

Widget buildDialogItem(Language language) => Row(
      children: <Widget>[
        Text(language.name,
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w300)),
      ],
    );
