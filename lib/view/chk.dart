// RoundButton(
//               ontap: () async {
//                 setState(() {
//                   loading = true;
//                 });

//                 try {
//                   firebase_storage.Reference ref =
//                       firebase_storage.FirebaseStorage.instance.ref(
//                           'Folder/${DateTime.now().millisecondsSinceEpoch}.jpg');

//                   // Upload image to Firebase Storage
//                   firebase_storage.UploadTask uploadTask = ref.putFile(_image!);

//                   // Wait for the upload task to complete and get the download URL
//                   firebase_storage.TaskSnapshot snapshot = await uploadTask;
//                   String downloadUrl = await snapshot.ref.getDownloadURL();
//                   print(downloadUrl);

//                   setState(() {
//                     loading = false;
//                   });

//                   Utils.toastMessage(context, 'Image Uploaded');
//                 } catch (error) {
//                   setState(() {
//                     loading = false;
//                   });

//                   Utils.toastMessage(context, error.toString());
//                 }
//               },
//               loading: loading,
//             )