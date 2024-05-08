//
//  SettingViewController.swift
//  LoginPageFire
//
//  Created by R95 on 23/04/24.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import FirebaseFirestoreInternal

class SettingViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var firstNameLableOutlet: UITextField!
    @IBOutlet weak var lastNameLableOutlet: UITextField!
    @IBOutlet weak var emailTextOutlet: UITextField!
    @IBOutlet weak var phoneLableOutlet: UITextField!
    @IBOutlet weak var imageViewOutlet: UIImageView!
    var userUID = ""
    var temp = 0
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        profile()
        imageViewOutlet.layer.cornerRadius = 39.5
    }
    
    //MARK: Keyboard Code
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    // MARK: Login Button Action.
    @IBAction func logOutlButAction(_ sender: Any) {
        Task { @MainActor in
            do{
                try Auth.auth().signOut()
                temp = 0
                alert(title: "Successfully!", message: "Successfully signing out! \n Please Re-Start App")
            }catch{
                temp = 1
                alert(title: "Error!", message: "Error while signing out!")
            }
        }
    }
    
    @IBAction func uploadButtonOutlet(_ sender: Any) {
        alert()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageViewOutlet.image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        dismiss(animated: true)
    }
    
    func alert() {
        let a = UIAlertController(title: "Secelct Photo", message: "", preferredStyle: .actionSheet)
        a.addAction(UIAlertAction(title: "Camera", style: .default))
        a.addAction(UIAlertAction(title: "Gallery", style: .default,handler: { _ in
            let a = UIImagePickerController()
            a.sourceType = .photoLibrary
            a.delegate = self
            a.allowsEditing = true
            self.present(a, animated: true)
        }))
        a.addAction(UIAlertAction(title: "Cansel", style: .destructive))
        present(a, animated: true)
    }
    
    @IBAction func saveButtonAction(_ sender: Any) {
//        saveProfileDeatil()
    }
}

//MARK: Alert Func.
extension SettingViewController {
    func alert(title: String, message: String) {
        if temp == 0 {
            let a = UIAlertController(title: title, message: message, preferredStyle: .alert)
            
            a.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { [self] _ in
                let naviagte = storyboard?.instantiateViewController(identifier: "LoginViewController") as! LoginViewController
                
                navigationController?.pushViewController(naviagte, animated: true)
            }))
            
            present(a, animated: true, completion: {
                a.view.superview?.isUserInteractionEnabled = true
                a.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.dismissOnTapOutside)))
            })
        }
        else {
            let a = UIAlertController(title: title, message: message, preferredStyle: .alert)
            a.addAction(UIAlertAction(title: "Ok", style: .cancel))
            present(a, animated: true, completion: {
                a.view.superview?.isUserInteractionEnabled = true
                a.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.dismissOnTapOutside)))
            })
        }
    }
    
    @objc func dismissOnTapOutside(){
        self.dismiss(animated: true, completion: nil)
    }
}

//MARK: Set the Profile Func.
extension SettingViewController {
    func profile() {
        DispatchQueue.main.async { [self] in
            Task { @MainActor in
                userUID = Auth.auth().currentUser?.uid ?? ""
                
                let snapshot = try await db.collection("User").getDocuments()
                for document in snapshot.documents {
                    if userUID == document.documentID {
                        if let firstName = document.data()["First Name"] as? String,
                           let lastName = document.data()["Last Name"] as? String,
                           let email = document.data()["Email"] as? String,
                           let phone = document.data()["Moblie Number"] as? String {
                            firstNameLableOutlet.text = firstName
                            lastNameLableOutlet.text = lastName
                            phoneLableOutlet.text = phone
                            emailTextOutlet.text = email
                        }
                    }
                }
            }
        }
    }
}

extension SettingViewController {
    func saveProfileDeatil() {
        Task { @MainActor in
            let snapshot = try await db.collection("User").getDocuments()
            for document in snapshot.documents {
                let firstName = firstNameLableOutlet.text
                let lastName = lastNameLableOutlet.text
                let email = emailTextOutlet.text
                let phone = phoneLableOutlet.text
                
                if email == document.data()["Email"] as! String ?? "" {
                    userUID = document.documentID
                    let newData = ["First Name": firstName,"Last Name": lastName,"Email": email,"Moblie Number": phone]
                    try await db.collection("User").document(userUID).setData(newData, merge: true)
                    temp = 1
                    alert(title: "Success!", message: "Your Profile has been successfully changed!")
                    resetEmailChange()
                }
                else {
                    print("false")
                }
            }
        }
    }
    
    func resetEmailChange() {
        Auth.auth().currentUser?.updateEmail(to: emailTextOutlet.text ?? "") { error in
            if error == nil {
                print("true")
            }
            else {
                print("false")
            }
        }
    }
}

/*
 Task { @MainActor in
 let user = Auth.auth().currentUser
 
 user?.delete { [self] error in
 if error != nil {
 temp = 1
 alert(title: "Error!", message: "Account Was Not Deleted!")
 print("false")
 } else {
 temp = 0
 alert(title: "Successfully!", message: "Account Was Deleted Successfully!")
 print("true")
 }
 }
 try await db.collection("User").document(Auth.auth().currentUser?.uid ?? "").delete()
 }
 */
