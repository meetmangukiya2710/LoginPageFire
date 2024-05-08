//
//  ForgotPasswordViewController.swift
//  LoginPageFire
//
//  Created by R95 on 17/04/24.
//

import UIKit
import FirebaseAuth
import FirebaseFirestoreInternal

class ForgotPasswordViewController: UIViewController {
    
    @IBOutlet weak var newPasswordLableOutlet: UITextField!
    @IBOutlet weak var confrimNewPasswordLableOutlet: UITextField!
    
    var temp = 0
    var userUID = ""
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(userUID)
    }
    
    @IBAction func resetPasswordButAction(_ sender: Any) {
        Task { @MainActor in
            let snapshot = try await db.collection("User").getDocuments()
            for document in snapshot.documents {
                let newPassword = confrimNewPasswordLableOutlet.text ?? ""
                let confirmNewPassword = newPasswordLableOutlet.text ?? ""
                
                if userUID == document.documentID {
                    if newPassword == confirmNewPassword {
                        let newPasswordData = ["Password": confirmNewPassword]
                        try await db.collection("User").document(userUID).setData(newPasswordData, merge: true)
                        resetPasswordChange()
                        temp = 1
                        alert(title: "Success!", message: "Your password has been successfully changed!")
                        
                    } else {
                        temp = 0
                        alert(title: "Error!", message: "Passwords do not match.")
                        
                    }
                }
                else {
                    print("false")
                }
            }
        }
    }
    
    func resetPasswordChange() {
        Auth.auth().currentUser?.updatePassword(to: confrimNewPasswordLableOutlet.text ?? "") { error in
            if error == nil {
                print("true")
            }
            else {
                print("false")
            }
        }
    }
}

//MARK: Alert Func. Code
extension ForgotPasswordViewController {
    
    func alert(title: String, message: String) {
        if temp == 0 {
            let a = UIAlertController(title: title, message: message, preferredStyle: .alert)
            
            a.addAction(UIAlertAction(title: "Ok", style: .cancel))
            
            present(a, animated: true, completion: {
                a.view.superview?.isUserInteractionEnabled = true
                a.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.dismissOnTapOutside)))
            })
        }
        else {
            let a = UIAlertController(title: title, message: message, preferredStyle: .alert)
            
            a.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { [self] alert in
                let naviagte = storyboard?.instantiateViewController(identifier: "LoginViewController") as! LoginViewController
                
                navigationController?.pushViewController(naviagte, animated: true)
            }))
            
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
