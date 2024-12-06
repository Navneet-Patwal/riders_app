import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../global/global_ins.dart';
import '../global/global_var.dart';
import '../view/mainscreen/home_screen.dart';
//import 'package:firebase_storage/firebase_storage.dart' as fStorage;

class AuthViewModel{
  ValidateSignUpForm(XFile? imageXFile,String password, String confirmPassword, String name, String email, String phone, String locationAddress, BuildContext context) async
  {
    if(imageXFile==null){
      commonViewModel.showSnackBar("Please Select Image File", context);
      return;
    }
    else{
      if(password == confirmPassword){
        if(name.isNotEmpty && email.isNotEmpty && password.isNotEmpty && phone.isNotEmpty && locationAddress.isNotEmpty){

          commonViewModel.showSnackBar("Please Wait!", context);

          User? currentFirebaseUser = await createUserInFirebaseAuth(email,password,context);
          //TODO uploadImageToStorage()
          String downloadUrl = "jik";
          await saveUserDataToFireStore(currentFirebaseUser, downloadUrl, name,email,password,locationAddress,phone);
          Navigator.push(context, MaterialPageRoute(builder: (c)=> HomeScreen()));
          commonViewModel.showSnackBar("Account created successfully!", context);
        }
        else{
          commonViewModel.showSnackBar("Please fill all fields", context);
          return;
        }
      }
      else{
        commonViewModel.showSnackBar("Password do not match", context);
        return;
      }
    }
  }


  createUserInFirebaseAuth(String email, String password,BuildContext context)async{
    User? currentFirebaseUser;
    await FirebaseAuth.instance.createUserWithEmailAndPassword
      (
        email: email,
        password: password
    ).then((valueAuth){
      currentFirebaseUser = valueAuth.user;
    }).catchError((errorMessage){
      commonViewModel.showSnackBar(errorMessage.toString(), context);
    });

    if(currentFirebaseUser==null){
      FirebaseAuth.instance.signOut();
      return;
    }
    return currentFirebaseUser;
  }

  // uploadImageToStorage(imageXFile){
  //   String downloadUrl = "";
  //     String fileName = DateTime.now().millisecondsSinceEpoch.toString();
  //     fStorage.Reference storageRef = fStorage.FirebaseStorage.instance.ref().child("ridersImages").child(fileName);
  //     fStorage.UploadTask uploadTask = storageRef.putFile(File(imageXFile!.path));
  //     fStorage.TaskSnapshot taskSnapshot = await uploadTask.whenComplete(()=> {});
  //     await taskSnapshot.ref.getDownloadURL().then((urlImage){
  //       downloadUrl = urlImage;
  //     });
  //     return downloadUrl;
  // }

  saveUserDataToFireStore(currentFirebaseUser, downloadUrl, name,email,password,locationAddress,phone) async
  {
    FirebaseFirestore.instance.collection("riders").doc(currentFirebaseUser.uid).set(
      {
        "uid":currentFirebaseUser.uid,
        "email": email,
        "name":name,
        "image": downloadUrl,
        "phone":phone,
        "address":locationAddress,
        "status":"approved",
        "earnings":0.0,
        "latitude":position?.latitude,
        "longitude":position?.longitude,
      }
    );
    sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences!.setString("uid", currentFirebaseUser.uid);
    await sharedPreferences!.setString("name", name);
    await sharedPreferences!.setString("email", email);
    await sharedPreferences!.setString("imageUrl", downloadUrl);

  }

  validateSignInForm( String email, String password, BuildContext context)  async {
    if (email.isNotEmpty && password.isNotEmpty) {
        commonViewModel.showSnackBar("Validating user....", context);
        User? currentFirebaseUser =  await loginUser(email, password, context);
       await readDataFromFirestoreAndSetDataLocally(currentFirebaseUser, context);
       Navigator.push(context, MaterialPageRoute(builder: (c)=> HomeScreen()));
    }else {
      commonViewModel.showSnackBar("All fields are required !", context);
      return;
    }
  }

  loginUser(email, password, context) async {
    User? currentFirebaseUser;
    await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password).then((valueAuth){
      currentFirebaseUser=valueAuth.user;
    }).catchError((errorMsg){
      commonViewModel.showSnackBar(errorMsg, context);
    });
    if(currentFirebaseUser == null){
      FirebaseAuth.instance.signOut();
      return;
    }
    return currentFirebaseUser;
  }

  readDataFromFirestoreAndSetDataLocally(User? currentFirebaseUser, BuildContext context) async {
    await FirebaseFirestore.instance.collection("riders")
        .doc(currentFirebaseUser!.uid)
        .get()
        .then((dataSnapShot) async{
          if(dataSnapShot.exists){
            if(dataSnapShot.data()!["status"] == "approved"){
              await sharedPreferences!.setString("uid",currentFirebaseUser.uid);
              await sharedPreferences!.setString("email", dataSnapShot.data()!["email"] );
              await sharedPreferences!.setString("name", dataSnapShot.data()!["name"] );
              await sharedPreferences!.setString("imagesUrl", dataSnapShot.data()!["image"] );
            }
            else{
              commonViewModel.showSnackBar("you are blocked.", context);
              FirebaseAuth.instance.signOut();
              return;
            }
          }
          else {
            commonViewModel.showSnackBar("This rider's record do not exists.", context);
            FirebaseAuth.instance.signOut();
            return;
          }
    });
  }
}