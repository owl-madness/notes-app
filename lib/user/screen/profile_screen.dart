import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:notes_app/user/controller/user_provider.dart';
import 'package:notes_app/utilities/appconfigs.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Profile',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      bottomNavigationBar: TextButton(
          onPressed: () => Provider.of<UserProvider>(context, listen: false)
              .onLogoutPressed(context),
          child: Container(
            height: 65,
            width: double.maxFinite,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: Colors.red, borderRadius: BorderRadius.circular(14)),
            child: const Text(
              'LOGOUT',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                  color: Colors.white),
            ),
          )),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Consumer<UserProvider>(
            builder: (context, userProvider, child) => StreamBuilder(
                stream: userProvider.userDataStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                        child: CircularProgressIndicator.adaptive());
                  }
                  if (snapshot.hasData) {
                    QueryDocumentSnapshot<Map<String, dynamic>>? userDoc =
                        (snapshot.data?.docs.isNotEmpty ?? false)
                            ? snapshot.data?.docs[0]
                            : null;
                    return Column(
                      children: [
                        const Icon(
                          Icons.person_pin,
                          size: 130,
                        ),
                        const SizedBox(
                          height: 30.0,
                        ),
                        TextFormField(
                          initialValue: userDoc?["note_user_name"] ?? '',
                          textAlign: TextAlign.center,
                          decoration: const InputDecoration(
                            hintText: 'Name',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(14),
                              ),
                            ),
                          ),onChanged: (value) => userProvider.nameString = value,
                        ),
                        const SizedBox(
                          height: 18.0,
                        ),
                        TextFormField(
                          initialValue: AppConfig.userData?.email,
                          textAlign: TextAlign.center,
                          decoration: const InputDecoration(
                            hintText: 'email',
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(14))),
                            enabled: false,
                          ),
                        ),
                        const SizedBox(
                          height: 18.0,
                        ),
                        TextFormField(
                          initialValue: (userDoc?["note_user_age"] ?? '').toString(),
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          decoration: const InputDecoration(
                            hintText: 'Age',
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(14),),),
                          ),
                          onChanged: (value) => userProvider.ageString = value,
                        ),
                        const SizedBox(
                          height: 25.0,
                        ),
                        TextButton(
                            onPressed: () => Provider.of<UserProvider>(context,
                                    listen: false)
                                .saveUserDate(context),
                            child: Container(
                              height: 50,
                              width: 150,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(14)),
                              child: const Text(
                                'Save',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17,
                                    color: Colors.white),
                              ),
                            )),
                      ],
                    );
                  }
                  return const Center(
                    child: Text("Something went wrong!"),
                  );
                }),
          ),
        ),
      ),
    );
  }
}
