import 'package:flutter/material.dart';
import 'package:my_app_1/screens/edit_physact_screen.dart';
import 'package:my_app_1/utils.dart';

class PhysicalActivity extends StatelessWidget {
  final int id;
  final String physicalActivityDescription;
  final Function reloadWidget;

  const PhysicalActivity({required this.id, required this.physicalActivityDescription, required this.reloadWidget});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90.0,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: const Color(0xffD0D0D0),
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: Column(
              children: [
                const Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Attività Fisica',
                    style: TextStyle(fontSize: 13.0),
                  ),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: SingleChildScrollView(
                          child: Text(
                            Utils.getFormattedText(physicalActivityDescription),
                            style: const TextStyle(fontSize: 18.0),
                            softWrap: true,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          await showModalBottomSheet(
                            context: context,
                            builder: (context) => EditPhysActScreen(
                              id: id,
                              physicalActivity: physicalActivityDescription,
                            ),
                          );
                          reloadWidget();
                        },
                        icon: const Icon(Icons.edit),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
