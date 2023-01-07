import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final textcontroller = TextEditingController();
  late int num1;
  late int num2;
  int answer = 0;

  @override
  void dispose(){
    textcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(answer.toString()),
            const SizedBox(height: 10,),
            TextField(
              decoration: const InputDecoration(labelText: "First Number"),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
              ],
              onChanged: (value1) => setState(() {
                num1 = int.parse(value1);
              }),
            ),
            const SizedBox(height: 5,),
            TextField(
              decoration: const InputDecoration(labelText: "Second Number"),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
              ],
              onChanged: (value2) => setState(() {
                num2 = int.parse(value2);
              }),
            ),
            const SizedBox(height: 20,),
            TextButton(
              onPressed: (){
                setState(() {
                  answer = num1 + num2;
                });
              }, 
              child: const Text("Add"),
            ),
          ],
        ),
      ),
    );
  }
}