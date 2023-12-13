// ignore_for_file: avoid_print

import 'package:asan_yab/data/models/users.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../domain/riverpod/data/profile_data_provider.dart';

class EditProfilePage extends ConsumerStatefulWidget {
  final Users userData;

  const EditProfilePage({super.key, required this.userData});

  @override
  ConsumerState<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends ConsumerState<EditProfilePage> {
  final user=FirebaseAuth.instance.currentUser;
  TextEditingController nameController=TextEditingController();
  TextEditingController lastNameController=TextEditingController();
  
  TextEditingController emailController=TextEditingController();
  @override
  void initState() {
    super.initState();
    nameController.text=widget.userData.name;
    emailController.text=widget.userData.email;
    lastNameController.text=widget.userData.lastName;
    editData();

  }

// Assuming you have access to FirebaseAuth instance and nameController

Future editData() async {
  try {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance.collection('User').doc(user.uid).update({
        'name': nameController.text,
        'lastName':lastNameController.text
        // Add other fields you want to update here
      });
      print('Data updated successfully!');
    } else {
      print('User is not authenticated!');
      // Handle case when user is not authenticated
    }
  } catch (error) {
    print('Error updating data: $error');
    // Handle error when updating data fails
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 280,
            child: Stack(
              children: [
                Container(
                  height: 220,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      Colors.white,
                      Colors.red.shade900,
                    ]),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.elliptical(600, 100),
                      bottomRight: Radius.elliptical(600, 100),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 48.0,right: 4),
                  child: IconButton(onPressed: (){
                    setState(() {
                      editData();
                    });
                     Navigator.pop(context);

                  },
                      icon: const Icon(Icons.arrow_back,size: 35,color: Colors.white,)),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 118.0, right: 116),
                  child:widget.userData.imageUrl==''
                      ? Stack(
                          children: [
                            const CircleAvatar(
                              radius: 80,
                              backgroundImage: AssetImage(
                                  'assets/Avatar.png'), // Your image URL
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 40.0, right: 50),
                              child: buildProgress(),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: IconButton(
                                  onPressed: () {
                                    showBottomSheets(context);
                                  },
                                  icon: const Icon(
                                    Icons.camera_alt,
                                    size: 32,
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      : Stack(children: [
                          CircleAvatar(
                            maxRadius: 80,
                            backgroundImage: NetworkImage(
                              '${ref.watch(imageProvider).imageUrl}',
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 40.0, right: 50),
                            child: buildProgress(),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: IconButton(
                                onPressed: () {
                                  showBottomSheets(context);
                                },
                                icon: const Icon(
                                  Icons.camera_alt,
                                  size: 32,
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                          ),
                        ],
                  ) ,
                ),
              ],
            ),
          ),
          Column(
            children: [
               TextField(
                        controller: nameController,
                        decoration: const InputDecoration(
                          labelText: 'Name',
                          
                          prefixIcon: Icon(
                            Icons.person_2_outlined,
                            color: Colors.red,
                            size: 30,
                          ),
                        ),
                      ),
                      TextField(
                        controller: lastNameController,
                        decoration: const InputDecoration(
                          labelText: 'lastName',
                          
                          prefixIcon: Icon(
                            Icons.person_2_outlined,
                            color: Colors.red,
                            size: 30,
                          ),
                        ),
                      ),
                      ListTile(
                      title: Text(widget.userData.email),
                      leading: const Icon(
                        color: Colors.red,
                        Icons.mail_outline,
                        size: 30,
                      ),
                    ),
                    const Divider(
                      color: Colors.grey,
                    ),
                      
                // ListView(
                //   children: [
                //     ListTile(
                //       title: Text(
                //           '${widget.userData.name} ${widget.userData.lastName}'),
                //       leading: const Icon(
                //         color: Colors.red,
                //         Icons.person_2_outlined,
                //         size: 30,
                //       ),
                //     ),
                //     const Divider(
                //       color: Colors.grey,
                //     ),
                //     ListTile(
                //       title: Text(widget.userData.email),
                //       leading: const Icon(
                //         color: Colors.red,
                //         Icons.mail_outline,
                //         size: 30,
                //       ),
                //     ),
                //     const Divider(
                //       color: Colors.grey,
                //     ),
                //   ],
                // ),
              
            ],
          ),
        ],
      ),
    );
  }

  Widget buildProgress() {
    return StreamBuilder<TaskSnapshot>(
      stream: ref.watch(imageProvider).uploadTask?.snapshotEvents,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final data = snapshot.data!;
          double progress = data.bytesTransferred / data.totalBytes;

          if (data.state == TaskState.success) {
            // If upload is complete, return an empty Container
            return Container();
          }

          return SizedBox(
            height: 50,
            width: 50,
            child: CircularProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey,
              color: Colors.red,
            ),
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }

  void showBottomSheets(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              InkWell(
                onTap: () {
                  // Handle Camera option
                  ref
                      .read(imageProvider.notifier)
                      .pickImage(ImageSource.camera);
                  Navigator.pop(context);
                },
                child: const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(Icons.camera),
                    SizedBox(height: 8.0),
                    Text('کامره'),
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  // Handle Gallery option
                  ref
                      .read(imageProvider.notifier)
                      .pickImage(ImageSource.gallery);
                  Navigator.pop(
                      context); // Call a function to handle Gallery action
                },
                child: const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(Icons.image),
                    SizedBox(height: 8.0),
                    Text('گالری'),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
