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
          User? currentFirebaseUser;
          try{
            await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password)
                .then((valueAuth)
            {
              currentFirebaseUser = valueAuth.user;
            });

          //TODO uploadImageToStorage()
          String downloadUrl = "https://plus.unsplash.com/premium_photo-1661842711348-dc6cdcc37468?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTd8fHJpZGVyfGVufDB8fDB8fHww";
          await saveUserDataToFireStoreForNewUser(currentFirebaseUser, downloadUrl, name,email,password,locationAddress,phone);
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (c)=> const HomeScreen()));
          commonViewModel.showSnackBar("Account created successfully!", context);
          return;
        } on FirebaseAuthException catch(e){
            if (e.code == 'email-already-in-use') {
              try{
                await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password).then((value){
                  currentFirebaseUser = value.user;
                });
              } on FirebaseAuthException catch(e){
                if(e.code == "wrong-password"){
                  currentFirebaseUser = null;
                }
              }
                  if(currentFirebaseUser == null) {
                    commonViewModel.showSnackBar(
                        "You are already registered with database type password of another app and signup",
                        context);
                    return;
                  }
              DocumentSnapshot userDoc = await FirebaseFirestore.instance
                  .collection("riders").doc(currentFirebaseUser!.uid).get();
              if (userDoc.exists && userDoc["loggedInApp"] == "rider") {
                commonViewModel.showSnackBar(
                    "Account already exists!", context);
                return;
              }
              String downloadUrl = "https://plus.unsplash.com/premium_vector-1721131162373-2d0df1719f5e?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTg3fHxwZXJzb258ZW58MHx8MHx8fDA%3D";
              await saveUserDataToFireStoreForOldUser(
                  currentFirebaseUser,
                  downloadUrl,
                  name,
                  email,
                  password,
                  locationAddress,
                  phone,
                  context);
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (c) => const HomeScreen()));
              commonViewModel.showSnackBar(
                  "Account created successfully!", context);
              return;
            } else {
              commonViewModel.showSnackBar(e.toString(), context);
              return;
            }
          }
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

  saveUserDataToFireStoreForNewUser(currentFirebaseUser, downloadUrl, name,email,password,locationAddress,phone) async
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
        "loggedInApp":"rider"
      }
    );
    sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences!.setString("uid", currentFirebaseUser.uid);
    await sharedPreferences!.setString("name", name);
    await sharedPreferences!.setString("email", email);
    await sharedPreferences!.setString("imageUrl", downloadUrl);

  }


  saveUserDataToFireStoreForOldUser(currentFirebaseUser, downloadUrl, name,email,password,locationAddress,phone,context) async
  {
    await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password).then((valueAuth){
      currentFirebaseUser=valueAuth.user;
    }).catchError((errorMsg){
      commonViewModel.showSnackBar(errorMsg, context);
    });
    FirebaseFirestore.instance.collection("riders").doc(currentFirebaseUser!.uid).set(
        {
          "uid":currentFirebaseUser!.uid,
          "email": email,
          "name":name,
          "image": downloadUrl,
          "phone":phone,
          "address":locationAddress,
          "status":"approved",
          "earnings":0.0,
          "latitude":position?.latitude,
          "longitude":position?.longitude,
          "loggedInApp":"rider"
        }
    );
    sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences!.setString("uid", currentFirebaseUser!.uid);
    await sharedPreferences!.setString("name", name);
    await sharedPreferences!.setString("email", email);
    await sharedPreferences!.setString("imageUrl", downloadUrl);

  }

  validateSignInForm( String email, String password, BuildContext context)  async {
    if (email.isNotEmpty && password.isNotEmpty) {
        commonViewModel.showSnackBar("Validating user....", context);
        User? currentFirebaseUser =  await loginUser(email, password, context);
      if(currentFirebaseUser != null){
        await readDataFromFirestoreAndSetDataLocally(currentFirebaseUser, context);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (c)=> const HomeScreen()));
      }
    }else {
      commonViewModel.showSnackBar("All fields are required !", context);
      return;
    }
  }

  loginUser(email, password, context) async {
    User? currentFirebaseUser;
    await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password).then((valueAuth) async {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection("riders").doc(valueAuth.user!.uid).get();
      if(userDoc.exists && userDoc["loggedInApp"] == "rider"){
        currentFirebaseUser=valueAuth.user;
      }
      else{
        commonViewModel.showSnackBar("No user found!", context);
        return;
      }
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