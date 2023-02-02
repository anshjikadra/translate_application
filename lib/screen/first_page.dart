import 'dart:developer';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:language_picker/language_picker_dropdown.dart';
import 'package:language_picker/language_picker.dart';
import 'package:language_picker/languages.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:text_to_speech/text_to_speech.dart';
import 'package:translate_application/data_base/book_mark/data_base_file.dart';
import 'package:translate_application/main.dart';
import 'package:translate_application/screen/bookmark.dart';
import 'package:translate_application/screen/model_class/api_model.dart';
import 'package:translate_application/screen/translate_page.dart';
import 'package:translate_application/screen/write_text.dart';
import 'package:translate_application/data_base/book_mark/dbmodel.dart';
import 'package:http/http.dart' as http;

//============global variable===============
//String language_select_n=pref.getString('selectlanguage_n') ?? "";
//String language_select_c=pref.getString('selectlanguage_c') ?? "";

String select_lanuage_l = pref.getString('select_l_l') ?? "en";
Language selectedDialogLanguagel = Language.fromIsoCode(select_lanuage_l);

String select_lanuage_r = pref.getString('select_l_r') ?? "gu";
Language selectedDialogLanguager = Language.fromIsoCode(select_lanuage_r);

bool swap_language = false;
String store_mic = " ";

//
// List<String> savefavoritie=pref.getStringList('bookmark') ?? [];
// List<String> save_history=pref.getStringList('save_h') ?? [];

// String selectedDialogLanguager = pref.getString('selcetlanguage') ?? "";

class first_page extends StatefulWidget {
  String? arabic, textwrit, s_h;

  first_page({
    this.arabic,
    this.textwrit,
    this.s_h,
  });

  @override
  State<first_page> createState() => _first_pageState();
}

class _first_pageState extends State<first_page> {
  //language picker

  bool firstp = false;
  String arabic_fav = "";

  //MIC

  SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = '';
  String secoundspeack = '';
  String s_lang_r = "";
  TextToSpeech tts = TextToSpeech();

  //API CALLING DATA CONVERT......

  Translate? answer;
  String arabicans = "";

  Future<String> createAlbum(String title) async {
    final response = await http.get(
      Uri.parse(
          'https://translate.googleapis.com/translate_a/single?client=gtx&dt=t&dt=bd&dj=1&dt=ex&dt=ld&dt=md&dt=qca&dt=rw&dt=rm&dt=ss&dt=at&sl=${selectedDialogLanguagel.isoCode}&tl=${selectedDialogLanguager.isoCode}&q=${widget.arabic}'),
    );
    if (response.statusCode == 200) {
      log(response.body);
      answer = Translate.fromJson(jsonDecode(response.body)['sentences'][0]);
      return arabicans = answer!.trans.toString();
    } else {
      throw Exception('Failed.......');
    }
  }

  @override
  void initState() {
    _initSpeech();

    // if(language_select_n.isNotEmpty&&language_select_c.isNotEmpty){
    //   selectedDialogLanguager=Language(language_select_n,language_select_c);
    //   setState(() {});
    // }
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
      widget.textwrit = result.recognizedWords;
      secoundspeack = result.recognizedWords;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              flex: 5,
              child: RotatedBox(
                quarterTurns: 2,
                child: Container(
                  color: Colors.teal,
                  child: Stack(
                    children: [
                      widget.textwrit == null
                          ? const SizedBox()
                          : Padding(
                              padding: const EdgeInsets.all(5),
                              child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    widget.arabic ?? "",
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        fontSize: 25, color: Colors.white),
                                  )),
                            ),
                      //widget.textwrit==null?Align(alignment: Alignment.center,child: Text(widget.textwrit==null?"": "${widget.arabic}",style: TextStyle(fontSize: 30,color: Colors.white),)):Align(alignment: Alignment.center,child: Text(widget.textwrit==null?"":"${widget.arabic}",style: TextStyle(fontSize: 30,color: Colors.white),)),
                      // firstp == false
                      //     ? Padding(
                      //         padding: EdgeInsets.all(5),
                      //         child: Align(
                      //             alignment: Alignment.center,
                      //             child: Text(
                      //               "${store_mic}",
                      //               style: TextStyle(
                      //                   fontSize: 70, color: Colors.white),
                      //             )),
                      //       ) : Padding(
                      //   padding: EdgeInsets.all(5),
                      //   child: Align(
                      //       alignment: Alignment.center,
                      //       child: Text(
                      //         "${widget.arabic}",
                      //         style: TextStyle(
                      //             fontSize: 20, color: Colors.white),
                      //       )),
                      // ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: InkWell(
                            child: Container(
                              decoration: const BoxDecoration(
                                  color: Colors.white, shape: BoxShape.circle),
                              height: 60,
                              width: 60,
                              child: Center(
                                  child: IconButton(
                                      onPressed: () async {
                                        firstp = false;
                                        if (_speechToText.isListening == true) {
                                          widget.arabic =
                                              widget.textwrit.toString();
                                          // print(store_mic);

                                          widget.arabic = await createAlbum(
                                              widget.arabic.toString());
                                          // print("ANSHWER==${store_mic}");
                                          setState(() {});
                                        }

                                        setState(() {});
                                        _speechToText.isNotListening
                                            ? _startListening()
                                            : _stopListening();
                                      },
                                      icon: _speechToText.isNotListening
                                          ? const Icon(
                                              Icons.mic_off_rounded,
                                              color: Colors.teal,
                                            )
                                          : const Icon(
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(15, 0, 0, 20),
                            child: IconButton(
                                onPressed: () {
                                  widget.textwrit == null
                                      ? const SizedBox()
                                      : tts.speak(widget.arabic.toString());
                                  tts.setVolume(15);
                                  tts.getVoice();
                                  setState(() {});
                                },
                                icon: const Icon(
                                  Icons.volume_up_outlined,
                                  size: 35,
                                  color: Colors.white,
                                )),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 15, 20),
                            child: IconButton(
                                onPressed: () async {
                                  widget.textwrit != null
                                      ? Clipboard.setData(
                                          ClipboardData(text: widget.arabic))
                                      : const SizedBox();
                                  widget.textwrit == null
                                      ? const SizedBox()
                                      : Fluttertoast.showToast(
                                          msg: "Text Copied",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor: Colors.black26,
                                          textColor: Colors.white,
                                          fontSize: 16.0);
                                  setState(() {});
                                },
                                icon: const Icon(
                                  Icons.copy,
                                  size: 35,
                                  color: Colors.white,
                                )),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
                flex: 1,
                child: Container(
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: LanguagePickerDropdown(
                          initialValue: swap_language
                              ? selectedDialogLanguager
                              : selectedDialogLanguagel,
                          onValuePicked: (Language language) => setState(() {
                            selectedDialogLanguagel = language;

                            String sl =
                                selectedDialogLanguagel.isoCode.toString();
                            pref.setString('select_l_l', sl);
                            select_lanuage_l = sl;

                            // selectedDialogLanguagel=select_lanuage_l.toString() as Language;
                            // selectedDialogLanguagel.name.toString()=select_lanuage_l.toString();
                            setState(() {});
                          }),
                          itemBuilder: buildDialogItem,
                        ),
                      ),
                      Align(
                        child: InkWell(
                            child: Container(
                          height: 50,
                          width: 50,
                          decoration: const BoxDecoration(
                              color: Colors.teal, shape: BoxShape.circle),
                          child: IconButton(
                              onPressed: () {
                                // swap_language = selectedDialogLanguagel;
                                // print("${swap_language!.name}");
                                // selectedDialogLanguagel=selectedDialogLanguager;
                                // print("${selectedDialogLanguagel.name}");
                                // selectedDialogLanguager= swap_language!;
                                // print("${selectedDialogLanguager.name}");
                                // setState(() {
                                //
                                // });

                                setState(() {
                                  swap_language = !swap_language;
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                        fullscreenDialog: true,
                                        builder: (context) => first_page(),
                                      ),
                                      (route) => false);
                                });
                              },
                              icon: const Icon(
                                Icons.swap_horiz_outlined,
                                size: 25,
                                color: Colors.white,
                              )),
                        )),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                          child: LanguagePickerDropdown(
                        initialValue: swap_language
                            ? selectedDialogLanguagel
                            : selectedDialogLanguager,
                        onValuePicked: (Language language) => setState(() {
                          selectedDialogLanguager = language;
                          // pref.setString('selectlanguage_n', language.name);
                          // pref.setString('selectlanguage_c', language.isoCode);

                          String sr =
                              selectedDialogLanguager.isoCode.toString();
                          pref.setString('select_l_r', sr);
                          select_lanuage_r = sr;

                          setState(() {});

                          // pref.setString('selcetlanguage',selectedDialogLanguager.toString());
                          // print("prefrence=====${selectedDialogLanguager}");
                        }),
                        itemBuilder: buildDialogItem,
                      )),
                    ],
                  ),
                )),
            Expanded(
              flex: 5,
              child: InkWell(
                onTap: () {
                  firstp = true;
                  setState(() {});
                  firstp == true
                      ? Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return write_text(
                              selectedDialogLanguageright:
                                  selectedDialogLanguager,
                              selectedDialogLanguageleft:
                                  selectedDialogLanguagel,
                              w_page: firstp,
                              t_page: false,
                            );
                          },
                        ))
                      : const SizedBox();
                },
                child: Container(
                  color: Colors.white,
                  child: Stack(
                    children: [
                      widget.textwrit == null
                          ? Padding(
                              padding: const EdgeInsets.all(5),
                              child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    widget.textwrit == null
                                        ? " "
                                        : "${widget.s_h}",
                                    style: const TextStyle(
                                        color: Colors.black, fontSize: 25),
                                  )))
                          : Padding(
                              padding: const EdgeInsets.all(5),
                              child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    textAlign: TextAlign.center,
                                    widget.textwrit == null
                                        ? " "
                                        : "${widget.textwrit}",
                                    style: const TextStyle(
                                        fontSize: 25, color: Colors.black),
                                  )),
                            ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(15, 0, 0, 20),
                        child: Align(
                          alignment: Alignment.bottomLeft,
                          child: IconButton(
                              onPressed: () {
                                showModalBottomSheet(
                                  context: context,
                                  builder: (context) {
                                    return SizedBox(
                                      height: 200,
                                      child: Column(
                                        children: [
                                          ListTile(
                                            onTap: () {
                                              //   Navigator.pushAndRemoveUntil(
                                              //       context, MaterialPageRoute(
                                              //     builder: (context) {
                                              //       return first_page();
                                              //     },
                                              //   ), (route) => false);
                                              Navigator.pushReplacement(context,
                                                  MaterialPageRoute(
                                                builder: (context) {
                                                  return first_page();
                                                },
                                              ));
                                            },
                                            leading: const Icon(
                                              Icons.translate,
                                              color: Colors.teal,
                                            ),
                                            title: const Text(
                                              "Interpret",
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                            trailing: const Text(
                                              "shared view",
                                              style:
                                                  TextStyle(color: Colors.grey),
                                            ),
                                          ),
                                          ListTile(
                                            onTap: () {
                                              firstp = false;

                                              firstp == true
                                                  ? Navigator
                                                      .pushAndRemoveUntil(
                                                          context,
                                                          MaterialPageRoute(
                                                      builder: (context) {
                                                        return first_page();
                                                      },
                                                    ), (route) => false)
                                                  : Navigator
                                                      .pushAndRemoveUntil(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) {
                                                          return traslate(
                                                              arabicans: widget
                                                                  .arabic
                                                                  .toString(),
                                                              textans: widget
                                                                  .textwrit
                                                                  .toString(),
                                                              ans_t: firstp);
                                                        },
                                                      ),
                                                      (route) => false,
                                                    );
                                            },
                                            leading: const Icon(
                                              Icons.chat,
                                              color: Colors.teal,
                                            ),
                                            title: const Text(
                                              "Translate",
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                            trailing: const Text(
                                              "solo view",
                                              style:
                                                  TextStyle(color: Colors.grey),
                                            ),
                                          ),
                                          ListTile(
                                            onTap: () {
                                              Navigator.pushReplacement(context,
                                                  MaterialPageRoute(
                                                builder: (context) {
                                                  return bookmark();
                                                },
                                              ));
                                            },
                                            leading: const Icon(
                                              Icons.star_border,
                                              color: Colors.teal,
                                            ),
                                            title: const Text(
                                              "Favorites",
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
                              icon: const Icon(
                                Icons.dehaze_rounded,
                                color: Colors.grey,
                                size: 35,
                              )),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: InkWell(
                            child: Container(
                              decoration: const BoxDecoration(
                                  color: Colors.teal, shape: BoxShape.circle),
                              height: 60,
                              width: 60,
                              child: Center(
                                  child: IconButton(
                                      onPressed: () async {
                                        firstp = false;
                                        if (_speechToText.isListening == true) {
                                          widget.arabic =
                                              widget.textwrit.toString();

                                          widget.arabic = await createAlbum(
                                              widget.arabic.toString());

                                          setState(() {});
                                        } else {}
                                        // print("Helo");
                                        setState(() {});
                                        _speechToText.isNotListening
                                            ? _startListening()
                                            : _stopListening();
                                      },
                                      icon: _speechToText.isNotListening
                                          ? const Icon(
                                              Icons.mic_off_rounded,
                                              color: Colors.white,
                                            )
                                          : const Icon(
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(15, 0, 0, 20),
                            child: IconButton(
                                onPressed: () {
                                  widget.textwrit == null
                                      ? const SizedBox()
                                      : tts.speak(widget.textwrit.toString());
                                  tts.setVolume(15);
                                  tts.getVoice();
                                  setState(() {});
                                },
                                icon: const Icon(
                                  Icons.volume_up_outlined,
                                  size: 35,
                                  color: Colors.grey,
                                )),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 15, 20),
                            child: IconButton(
                                onPressed: () async {
                                  widget.textwrit == null
                                      ? const SizedBox()
                                      : DB.save(Data(
                                          save_bookmark:
                                              widget.textwrit.toString()));

                                  setState(() {
                                    firstp = true;
                                  });

                                  widget.textwrit != null
                                      ? Fluttertoast.showToast(
                                          msg: "Added to favorities",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor: Colors.black26,
                                          textColor: Colors.white,
                                          fontSize: 16.0)
                                      : "";
                                },
                                icon: firstp == true
                                    ? IconButton(
                                        onPressed: () {
                                          // savefavoritie.remove(widget.textans);
                                          // pref.setStringList('bookmark',savefavoritie);

                                          setState(() {});
                                          firstp = false;
                                          firstp == false
                                              ? const Icon(Icons.star_border)
                                              : widget.textwrit == null
                                                  ? const Icon(
                                                      Icons.star_border,
                                                      size: 35,
                                                      color: Colors.grey,
                                                    )
                                                  : const Icon(
                                                      Icons.star,
                                                      size: 35,
                                                      color: Colors.grey,
                                                    );
                                        },
                                        icon: widget.textwrit == null
                                            ? const Icon(
                                                Icons.star_border,
                                                color: Colors.grey,
                                                size: 25,
                                              )
                                            : const Icon(Icons.star))
                                    : const Icon(
                                        Icons.star_border,
                                        size: 35,
                                        color: Colors.grey,
                                      )),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget buildDialogItem(Language language) => Row(
      children: <Widget>[
        Text(language.name,
            style: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.w300)),
      ],
    );



/*
IconButton(
                              onPressed: () async {
                                widget.textwrit == null
                                    ? SizedBox()
                                    : DB.save(Data(save_bookmark: widget.textwrit.toString()));


                                setState(() {
                                  firstp = true;
                                  print("starttap==${firstp}==");
                                });

                                widget.textwrit != null
                                    ? Fluttertoast.showToast(
                                    msg: "Added to favorities",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.black26,
                                    textColor: Colors.white,
                                    fontSize: 16.0)
                                    : "";
                              },
                              icon:firstp == true
                                  ? IconButton(
                                  onPressed: () {



                                    print("I am in");

                                    setState(() {});
                                    firstp = false;
                                    firstp == false
                                        ? Icon(Icons.star_border,size: 35,
                                      color: Colors.grey,)
                                        : widget.textwrit == null
                                        ? Icon(Icons.star_border,size: 35,
                                      color: Colors.grey,)
                                        : Icon(Icons.star,size: 35,
                                      color: Colors.grey,);
                                  },
                                  icon: widget.textwrit == null
                                      ? Icon(Icons.star_border,size: 35,
                                    color: Colors.grey,)
                                      : Icon(Icons.star,size: 35,
                                    color: Colors.grey,)


                              )
                                  : Icon(Icons.star_border,size: 35,color: Colors.grey,),
                            )
)*/
