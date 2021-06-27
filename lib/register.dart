import 'package:bjp_pdf/pdf_api.dart';
import 'package:bjp_pdf/pdf_paragraph.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Register extends StatefulWidget {
  final String? restorationId;

  const Register({Key? key, this.restorationId}) : super(key: key);
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> with RestorationMixin {
  TextEditingController pressno = TextEditingController();
  TextEditingController date = TextEditingController();
  TextEditingController header = TextEditingController();
  TextEditingController detail = TextEditingController();
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  Future<void> saveValues() async {
    final SharedPreferences prefs = await _prefs;
    setState(() {
      prefs.setString("pressno", pressno.text.toString().trim());
      prefs.setString("date",
          "${_selectedDate.value.day}/${_selectedDate.value.month}/${_selectedDate.value.year}");
      prefs.setString("header", header.text.toString());
      prefs.setString("detail", detail.text.toString());
    });
  }

  @override
  String? get restorationId => widget.restorationId;

  final RestorableDateTime _selectedDate = RestorableDateTime(DateTime.now());
  late final RestorableRouteFuture<DateTime?> _restorableDatePickerRouteFuture =
      RestorableRouteFuture<DateTime?>(
    onComplete: _selectDate,
    onPresent: (NavigatorState navigator, Object? arguments) {
      return navigator.restorablePush(
        _datePickerRoute,
        arguments: _selectedDate.value.millisecondsSinceEpoch,
      );
    },
  );

  static Route<DateTime> _datePickerRoute(
    BuildContext context,
    Object? arguments,
  ) {
    return DialogRoute<DateTime>(
      context: context,
      builder: (BuildContext context) {
        return DatePickerDialog(
          restorationId: 'date_picker_dialog',
          initialEntryMode: DatePickerEntryMode.calendarOnly,
          initialDate: DateTime.fromMillisecondsSinceEpoch(arguments! as int),
          firstDate: DateTime(2021, 1, 1),
          lastDate: DateTime(2022, 1, 1),
        );
      },
    );
  }

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_selectedDate, 'selected_date');
    registerForRestoration(
        _restorableDatePickerRouteFuture, 'date_picker_route_future');
  }

  void _selectDate(DateTime? newSelectedDate) {
    if (newSelectedDate != null) {
      setState(() {
        _selectedDate.value = newSelectedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 20,
          ),
          Center(
            child: Image.asset(
              'images/bjp_logo.png',
              width: 60,
              height: 60,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Center(
            child: Text(
              "Press Note Release",
              style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red),
            ),
          ),
          Container(
            // padding: EdgeInsets.all(5),
            margin: EdgeInsets.all(20),
            child: TextFormField(
              controller: pressno,
              onFieldSubmitted: (String value) {
                saveValues();
              },
              decoration: new InputDecoration(
                labelText: "Press Note No.",
                fillColor: Colors.white,
                border: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(5.0),
                  borderSide: new BorderSide(),
                ),
              ),
              keyboardType: TextInputType.emailAddress,
              style: new TextStyle(
                fontFamily: "Poppins",
              ),
            ),
          ),
          InkWell(
            onTap: () {
              _restorableDatePickerRouteFuture.present();
            },
            child: Container(
              margin: EdgeInsets.all(20),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: Colors.grey)),
              padding: EdgeInsets.all(20),
              child: Text(
                  "${_selectedDate.value.day}/${_selectedDate.value.month}/${_selectedDate.value.year}"),
            ),
          ),
          Container(
            margin: EdgeInsets.all(20),
            child: TextField(
              controller: header,
              maxLength: null,
              maxLines: null,
              decoration: new InputDecoration(
                labelText: "Header",
                fillColor: Colors.white,
                border: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(5.0),
                  borderSide: new BorderSide(),
                ),
              ),
              // keyboardType: TextInputType.multiline,
              style: new TextStyle(
                fontFamily: "Poppins",
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.all(20),
            child: TextField(
              controller: detail,
              maxLength: null,
              maxLines: null,
              decoration: new InputDecoration(
                labelText: "Details",
                fillColor: Colors.white,
                border: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(5.0),
                  borderSide: new BorderSide(),
                ),
              ),
              style: new TextStyle(
                fontFamily: "Poppins",
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                // Expanded(
                //   child: Container(
                //     height: 50,
                //     child: ElevatedButton(
                //       onPressed: () async {
                //         await Printing.sharePdf(filename: 'Document.pdf');
                //         // saveValues();
                //         // final pdfFile = await PdfParagraphApi.generate();
                //         // Share.shareFiles(['${pdfFile.path}'],
                //         //     text: 'Press Note Release');
                //       },
                //       child: Text("Export"),
                //     ),
                //   ),
                // ),
                // SizedBox(
                //   width: 20,
                // ),
                Expanded(
                  child: Container(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () async {
                        await Printing.layoutPdf(
                            onLayout: (PdfPageFormat format) async =>
                                await Printing.convertHtml(
                                  format: format,
                                  html:
                                      '<html><style>p.padding {padding-left: 1cm;}</style><img src="https://hrminfosec.com/images/bjp/letterhead1.jpg" width="1100" height="200"/><body>\n\n<p class ="padding" style="font-size:20px" >Press No. : ${pressno.text}\n\n</p>\n<p class ="padding" style="font-size:20px" >Date : ${_selectedDate.value.day}/${_selectedDate.value.month}/${_selectedDate.value.year}</p>\n\n<p class ="padding" style="font-size:20px" ><u>${header.text}</p></u>\n\n<p class ="padding" style="font-size:20px" >${detail.text}</p>\n\n<img src="https://hrminfosec.com/images/bjp/letterhead2.jpg"width="1100" height="200"/></body></html>', // pass generated html here
                                ));
                        // saveValues();
                        // final pdfFile = await PdfParagraphApi.generate();
                        // debugPrint("path ${pdfFile.path}");
                        // PdfApi.openFile(pdfFile);
                      },
                      child: Text("Save"),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
