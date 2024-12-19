import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HabitListScreen extends StatelessWidget {
  final CollectionReference doctorAppointments =
      FirebaseFirestore.instance.collection('doctorAppointments');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Doctor Appointment List'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Your Doctor Appointments',
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addNewDoctorAppointment,
              child: Text('Add Doctor Appointment'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: doctorAppointments.snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text('No doctor appointments found.'));
                  }
                  final doctorAppointmentDocs = snapshot.data!.docs;
                  return ListView.builder(
                    itemCount: doctorAppointmentDocs.length,
                    itemBuilder: (context, index) {
                      String doctorAppointmentId =
                          doctorAppointmentDocs[index].id;
                      return ListTile(
                        title: Text(doctorAppointmentDocs[index]['title']),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () {
                                _updateDoctorAppointment(doctorAppointmentId);
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                _deleteDoctorAppointment(doctorAppointmentId);
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _addNewDoctorAppointment() {
    doctorAppointments.add({
      'title': 'New Doctor Appointment',
      'status': 'Active',
    });
  }

  void _updateDoctorAppointment(String doctorAppointmentId) {
    doctorAppointments.doc(doctorAppointmentId).update({
      'status': 'Updated Status',
    });
  }

  void _deleteDoctorAppointment(String doctorAppointmentId) {
    doctorAppointments.doc(doctorAppointmentId).delete();
  }
}
