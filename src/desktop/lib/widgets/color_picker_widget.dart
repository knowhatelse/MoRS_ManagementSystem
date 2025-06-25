import 'package:flutter/material.dart';

class ColorPickerWidget {
  static const List<Color> availableColors = [
    Colors.red,
    Colors.pink,
    Colors.purple,
    Colors.deepPurple,
    Colors.indigo,
    Colors.blue,
    Colors.lightBlue,
    Colors.cyan,
    Colors.teal,
    Colors.green,
    Colors.lightGreen,
    Colors.lime,
    Colors.yellow,
    Colors.amber,
    Colors.orange,
    Colors.deepOrange,
    Colors.brown,
    Colors.grey,
    Colors.blueGrey,
  ];

  static Future<Color?> showColorPicker(
    BuildContext context,
    Color currentColor,
  ) {
    return showDialog<Color>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Odaberite boju'),
          content: SingleChildScrollView(
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: availableColors
                  .map(
                    (color) => GestureDetector(
                      onTap: () => Navigator.of(context).pop(color),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(20),
                          border: currentColor == color
                              ? Border.all(color: Colors.black, width: 3)
                              : Border.all(color: Colors.grey, width: 1),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Otkaži'),
            ),
          ],
        );
      },
    );
  }
}
