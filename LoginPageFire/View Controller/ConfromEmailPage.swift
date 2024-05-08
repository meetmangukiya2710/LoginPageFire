//
//  ConfromEmailPage.swift
//  LoginPageFire
//
//  Created by R95 on 19/04/24.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import FirebaseFirestoreInternal

class ConfromEmailPage: UIViewController {
    
    @IBOutlet weak var emailTextFieldOutlet: UITextField!
    let db = Firestore.firestore()
    var userUID = ""
    var email = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
    }
    
    @IBAction func resetPasswordButOutlet(_ sender: Any) {
        Task { @MainActor in
            let snapshot = try await db.collection("User").getDocuments()
            
            for document in snapshot.documents {
                let email = document.data()["Email"]
                if email as! String == emailTextFieldOutlet.text ?? "" {
                    print("true")
                    userUID = document.documentID
                    alert(title: "Done!", message: "Your Email Is Correct!")
                    break
                }
            }
        }
    }
}

extension ConfromEmailPage {
    
    func alert(title: String, message: String) {
        
        let a = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        a.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { [self] alert in
            let naviagte = storyboard?.instantiateViewController(identifier: "ForgotPasswordViewController") as! ForgotPasswordViewController
            naviagte.userUID = userUID
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
