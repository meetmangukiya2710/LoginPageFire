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
    var temp = 0
    let db = Firestore.firestore()
    var userUID =  ""
    
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
}

//MARK: Alert Func.
extension SettingViewController {
    func alert(title: String, message: String) {
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
    
    @objc func dismissOnTapOutside(){
        self.dismiss(animated: true, completion: nil)
    }
}

//MARK: Set the Profile Func.
extension SettingViewController {
    func profile() {
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
