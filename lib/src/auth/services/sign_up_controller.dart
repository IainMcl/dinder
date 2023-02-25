import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dinder/src/auth/models/file_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dinder/src/user/models/user.dart' as account_user;

class SignUpController extends GetxController {
  static SignUpController get instance => Get.find();
  FileModel? _imageFile;
  FileModel? get imageFile => _imageFile;
  void setImageFile(FileModel? file) {
    _imageFile = file;
    debugPrint("Updated ImageFile: ${imageFile!.filename}");
    update();
  }

  FileModel? _resumeFile;
  FileModel? get resumeFile => _resumeFile;
  void setResumeFile(FileModel? file) {
    _resumeFile = file;
    debugPrint("Updated ResumeFile: ${resumeFile!.filename}");
    update();
  }

  String? _userType = "Student";
  String? get userType => _userType;
  void setUserType(String? text) {
    _userType = text;
    debugPrint("Updated userType: $userType");
    update();
  }

  String? _name;
  String? get name => _name;
  void setName(String? text) {
    _name = text;
    debugPrint("Updated name: $name");
    update();
  }

  String? _email;
  String? get email => _email;
  void setEmail(String? text) {
    _email = text;
    debugPrint("Updated email: $email");
    update();
  }

  String? _password;
  String? get password => _password;
  void setPassword(String? text) {
    _password = text;
    debugPrint("Updated password: $password");
    update();
  }

  String? _mobileNumber;
  String? get mobileNumber => _mobileNumber;
  void setMobileNumber(String? text) {
    _mobileNumber = text;
    debugPrint("Updated mobileNumber: $mobileNumber");
    update();
  }

  String? _collegeName;
  String? get collegeName => _collegeName;
  void setCollegeName(String? text) {
    _collegeName = text;
    debugPrint("Updated collegeName: $collegeName");
    update();
  }

  String? _admissionYear;
  String? get admissionYear => _admissionYear;
  void setAdmissionYear(String? text) {
    _admissionYear = text;
    debugPrint("Updated admissionYear: $admissionYear");
    update();
  }

  String? _passOutYear;
  String? get passOutYear => _passOutYear;
  void setPassOutYear(String? text) {
    _passOutYear = text;
    debugPrint("Updated passOutYear: $passOutYear");
    update();
  }

  Future postSignUpDetails() async {
    await FirebaseFirestore.instance.collection("user").add({
      "email": email,
      "password": password,
    });
  }

  Future uploadImageFile() async {
    await FirebaseStorage.instance
        .ref('files/${imageFile!.filename}')
        .putData(imageFile!.fileBytes);
  }

  Future uploadResumeFile() async {
    await FirebaseStorage.instance
        .ref('files/${resumeFile!.filename}')
        .putData(resumeFile!.fileBytes);
  }

  Future<bool> registerUser(String email, String password) async {
    try {
      var response = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // create User in Firestore
      account_user.User user = account_user.User(email: email, name: name);
      user.id = response.user!.uid;
      user.saveUser();

      return true;
    } catch (error) {
      if (error is FirebaseAuthException) {
        Get.showSnackbar(GetSnackBar(
          message: error.toString(),
        ));
      }
    }
    return false;
  }
}
