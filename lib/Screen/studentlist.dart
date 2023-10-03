import 'dart:io';

import 'package:flutter/material.dart';
import 'package:week_05_db/Screen/addstudent.dart';
import 'package:week_05_db/Screen/updatestudent.dart';
import 'package:week_05_db/database/databasesqlite.dart';

class StudentListScrn extends StatefulWidget {
  const StudentListScrn({super.key});

  @override
  State<StudentListScrn> createState() => _StudentListScrnState();
}

final searchController = TextEditingController();
late List<Map<String, dynamic>> _studentsData = [];

class _StudentListScrnState extends State<StudentListScrn> {
  @override
  Future<void> fetchStudentData() async {
    List<Map<String, dynamic>> students = await getAllStudentDataFromDB();

    if (searchController.text.isNotEmpty) {
      students = students
          .where((student) => student['studentname']
              .toString()
              .toLowerCase()
              .contains(searchController.text.toLowerCase()))
          .toList();
    }
    setState(() {
      _studentsData = students;
    });
  }

  void initState() {
    fetchStudentData();
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("List of Students"),
        centerTitle: true,
        foregroundColor: Colors.blue.shade600,
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextFormField(
              controller: searchController,
              onChanged: (value) {
                setState(() {
                  fetchStudentData();
                });
              },
              decoration: const InputDecoration(
                  label: Text("Search"), border: OutlineInputBorder()),
            ),
            const SizedBox(height: 20),
            _studentsData.isEmpty
                ? const Center(child: Text("No students available."))
                : Expanded(
                    child: ListView.separated(
                      itemCount: _studentsData.length,
                      itemBuilder: (context, index) {
                        final student = _studentsData[index];
                        final id = student['id'];
                        final imageurl = student['imagesrc'];
                        final name = student['studentname'];
                        return ListTile(
                          title: Text(name),
                          leading: CircleAvatar(
                            radius: 40,
                            backgroundImage: FileImage(File(imageurl)),
                          ),
                          subtitle: Text(id.toString()),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.yellow,
                                child: IconButton(
                                  onPressed: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (context) =>
                                          UpdateStudentDetails(
                                        id: id,
                                        age: student['age'],
                                        name: name,
                                        place: student['place'],
                                        imageSrc: imageurl,
                                        number: student['number'],
                                      ),
                                    ));
                                  },
                                  icon: const Icon(Icons.edit),
                                ),
                              ),
                              const SizedBox(width: 15),
                              CircleAvatar(
                                backgroundColor: Colors.yellow,
                                child: IconButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: const Text(
                                              "Delete The Student Information"),
                                          content: const Text(
                                              "Are you sure you want to delete ?"),
                                          actions: [
                                            ElevatedButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text("Cancel")),
                                            ElevatedButton(
                                                onPressed: () async {
                                                  await deleteStudentDetailsFromDB(
                                                      id);
                                                  fetchStudentData();
                                                  Navigator.of(context).pop();
                                                  snackBarFunction(
                                                      context,
                                                      "Successfully Delete the student Details",
                                                      Colors.green);
                                                },
                                                child: const Text("Ok"))
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  icon: const Icon(Icons.delete),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return const SizedBox(height: 10);
                      },
                    ),
                  )
          ],
        ),
      ),
    );
  }
}
