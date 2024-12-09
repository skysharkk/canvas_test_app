import 'package:flutter/material.dart';

typedef UpdateLength = void Function(List<double> value);

class LengthModal extends StatefulWidget {
  final UpdateLength? updateLength;
  final List<double> linesLength;
  const LengthModal({super.key, required this.linesLength, this.updateLength});

  @override
  State<StatefulWidget> createState() => _LengthModalState();
}

class _LengthModalState extends State<LengthModal> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      child: SizedBox(
        width: double.infinity,
          child: Column(children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Редактирование длин сторон', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      for (int i = 0; i < widget.linesLength.length; i++)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: TextField(
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'Сторона ${i + 1}',
                              border: const OutlineInputBorder(),
                            ),
                            onChanged: (value) {
                              double? parsedValue = double.tryParse(value);
                                if(parsedValue != null) {
                                  widget.linesLength[i] = parsedValue;
                                }
                            },
                            controller: TextEditingController(text: widget.linesLength[i].toStringAsFixed(1)),
                          ),
                        ),
                    ],
                  ),
                )
              ),
            ),
            SizedBox(
              child: ElevatedButton(
                onPressed: () {
                  widget.updateLength!(widget.linesLength);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
                child: const Text('Применить', style: TextStyle(color: Colors.white)),
              )
            )
          ]),
      ),
    );
  }
}

