import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../widgets/appointment_type_chart.dart';
import '../constants/app_constants.dart';
import '../models/appointment/appointment_response.dart';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:flutter/rendering.dart';

class AppointmentGraphDialog extends StatelessWidget {
  final List appointments;
  AppointmentGraphDialog({super.key, required this.appointments});

  final GlobalKey chartKey = GlobalKey();

  Future<void> _saveAsPdf(BuildContext context) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    try {
      RenderRepaintBoundary boundary =
          chartKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image.toByteData(
        format: ui.ImageByteFormat.png,
      );
      Uint8List pngBytes = byteData!.buffer.asUint8List();
      final pdf = pw.Document();
      final now = DateTime.now();
      pdf.addPage(
        pw.Page(
          build: (pw.Context context) => pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Termini kroz vrijeme po tipu',
                style: pw.TextStyle(
                  fontSize: 22,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 16),
              pw.Image(pw.MemoryImage(pngBytes)),
              pw.SizedBox(height: 16),
              pw.Text(
                'Datum: ${DateFormat('dd.MM.yyyy').format(now)}',
                style: pw.TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
      );
      final bytes = await pdf.save();
      await Printing.sharePdf(
        bytes: bytes,
        filename:
            'termini_graf_${DateFormat('yyyyMMdd_HHmmss').format(now)}.pdf',
      );
    } catch (e) {
      scaffoldMessenger.showSnackBar(
        SnackBar(content: Text('Greška pri spremanju PDF-a: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    return AlertDialog(
      backgroundColor: Colors.white,
      titlePadding: EdgeInsets.zero,
      contentPadding: const EdgeInsets.all(32),
      title: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppConstants.primaryBlue,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Row(
          children: [
            const Icon(Icons.show_chart, color: Colors.white, size: 24),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'Termini kroz vrijeme po tipu',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                ),
              ),
            ),
            IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.close, color: Colors.white, size: 20),
              constraints: const BoxConstraints(),
              padding: EdgeInsets.zero,
            ),
          ],
        ),
      ),
      content: SizedBox(
        width: 1100,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 540,
                child: RepaintBoundary(
                  key: chartKey,
                  child: AppointmentTypeChart(
                    appointments: appointments.cast<AppointmentResponse>(),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => _saveAsPdf(context),
                    icon: const Icon(Icons.picture_as_pdf),
                    label: const Text('Spremi kao PDF'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppConstants.primaryBlue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.bottomRight,
                child: Text(
                  DateFormat('dd.MM.yyyy').format(now),
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
