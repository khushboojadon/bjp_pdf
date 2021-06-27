import 'dart:io';
import 'dart:typed_data';
import 'package:bjp_pdf/pdf_api.dart';
import 'package:bjp_pdf/register.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:mustache_template/mustache_template.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:universal_html/parsing.dart';

class PdfParagraphApi {
  static Register register = Register();

  static Future<File> generate() async {
    final pdf = pw.Document();
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    final String pressno = prefs.getString('pressno') as String;
    final String date = prefs.getString('date') as String;
    var header = prefs.getString('header') as String;
    final String detail = prefs.getString('detail') as String;
    final headerPng =
        (await rootBundle.load('images/header.png')).buffer.asUint8List();
    final footerPng =
        (await rootBundle.load('images/footer.png')).buffer.asUint8List();
    // final customFont =
    //     Font.ttf(await rootBundle.load('assets/fonts/MuktaVaani-Medium.ttf'));
    final Uint8List fontData =
        (await rootBundle.load('assets/fonts/MuktaVaani-Medium.ttf'))
            .buffer
            .asUint8List();
    final ttf = Font.ttf(fontData.buffer.asByteData());
    // final htmlDocument = parseHtmlDocument(
    //     '<html><body>ગુજરાત કોંગ્રેસ પક્ષના પ્રભારી શ્રી રાજીવ સાતવજી આકસ્મિક નિધન નથી પરિવાર ઉપર આવી પડેલ આકસ્મિક દુઃખ સહન</body></html>');

    const htmldata =
        """ગુજરાત કોંગ્રેસ પક્ષના પ્રભારી શ્રી રાજીવ સાતવજી આકસ્મિક નિધન નથી પરિવાર ઉપર આવી પડેલ આકસ્મિક દુઃખ સહન કરવાની પરમ કૃપાળુ પરમાત્મા શક્તિ આપે-શ્રી સી આર પાટીલ શ્રી રાજીવ સાતવજીનું આકસ્મિક નિધન એ ગુજરાત કોંગ્રેસ પક્ષ માટે વજ્રઘાત સમાન છે-શ્રી સી આર પાટી શ્રી રાજીવ સાતવજીના આકસ્મિક નિધનથી ગુજરાત કોંગ્રેસે એક સફળ રણનીતિકાર ગુમાવ્યો છે-શ્રી સી આર પાટીલ""";
    // var template = Template(
    //   htmldata,
    //   lenient: true,
    //   name: 'source.html',
    //   htmlEscapeValues: true,
    // );
    var t = new Template('{{ author }}');
    // var output = t.renderString({
    //   'author':
    //       'ગુજરાત કોંગ્રેસ પક્ષના પ્રભારી શ્રી રાજીવ સાતવજી આકસ્મિક નિધન નથી પરિવાર'
    // });

    pdf.addPage(
      pw.MultiPage(
        build: (context) => <pw.Widget>[
          pw.Image(pw.MemoryImage(headerPng)),
          pw.Column(children: [
            pw.SizedBox(height: 5),
            pw.Row(children: [
              pw.SizedBox(width: 20),
              pw.Text("Press No. :"),
              pw.Spacer(),
              pw.Text("Date : $date"),
            ]),
            pw.SizedBox(height: 5),
          ]),
          pw.Paragraph(
            padding: pw.EdgeInsets.only(left: 20),
            text: '''${header.toString()}''',
            style: TextStyle(
              fontSize: 6,
              font: ttf,
              decoration: pw.TextDecoration.underline,
              color: PdfColors.blue900,
            ),
          ),
          pw.SizedBox(height: 5),
          pw.Paragraph(
            padding: pw.EdgeInsets.only(left: 20),
            text: '''
            $htmldata
            ''',
            style: TextStyle(fontSize: 6, font: ttf, color: PdfColors.black),
          ),
          pw.SizedBox(height: 5),
          pw.Image(pw.MemoryImage(footerPng)),
        ],
        footer: (context) {
          final text = 'Page ${context.pageNumber} of ${context.pagesCount}';
          return pw.Container(
            alignment: pw.Alignment.centerRight,
            margin: pw.EdgeInsets.only(top: 1 * PdfPageFormat.cm),
            child: pw.Text(
              text,
              style: pw.TextStyle(color: PdfColors.black),
            ),
          );
        },
      ),
    );
    return PdfApi.saveDocument(name: 'press_note_release.pdf', pdf: pdf);
  }
}
