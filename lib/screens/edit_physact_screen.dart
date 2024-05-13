import 'package:flutter/material.dart';
import 'package:my_app_1/models/diary_data.dart';

import '../utils.dart';

class EditPhysActScreen extends StatefulWidget {
  final int id;
  final String physicalActivity;

  const EditPhysActScreen({required this.id, required this.physicalActivity});

  @override
  State<EditPhysActScreen> createState() => _EditPhysActScreenState();
}

class _EditPhysActScreenState extends State<EditPhysActScreen> {
  late String physicalActivity;

  @override
  void initState() {
    super.initState();
    physicalActivity = widget.physicalActivity;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.0),
        color: const Color(0xffF9EBE1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  (physicalActivity == "")?'Inserisci attività fisica':'Modifica attività fisica',
                  style: const TextStyle(color: Color(0xff3E4A55), fontSize: 25.0, fontWeight: FontWeight.bold),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await DiaryData().updatePhysicalActivity(Utils.db, widget.id, physicalActivity);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xffE8C9B8),
                    padding: const EdgeInsets.all(20.0),
                  ),
                  child: const Text(
                    'Salva',
                    style: TextStyle(color: Color(0xff3E4A55), fontSize: 20.0),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            TextField(
              autofocus: true,
              maxLines: null,
              controller: TextEditingController(text: physicalActivity),
              decoration: const InputDecoration(
                hintText: 'Inserisci attività fisica',
                hintStyle: TextStyle(color: Colors.blueGrey),
                border: OutlineInputBorder(),
              ),
              style: const TextStyle(color: Color(0xff3E4A55)),
              onChanged: (value) => physicalActivity = value,
            ),
          ],
        ),
      ),
    );
  }
}
