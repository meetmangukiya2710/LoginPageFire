//
//  LoginViewController.swift
//  LoginPageFire
//
//  Created by R95 on 16/04/24.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import GoogleSignIn
import FirebaseFirestore

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailLableOutlet: UITextField!
    @IBOutlet weak var passwordLableOutlet: UITextField!
    @IBOutlet weak var googleButnOutlet: UIButton!
    var temp = 0
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        design()
    }
    
    //MARK: Keyboard Code
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    //MARK: Login Button
    @IBAction func loginButtonAciton(_ sender: Any) {
        Auth.auth().signIn(withEmail: emailLableOutlet.text ?? "", password: passwordLableOutlet.text ?? "") { [self] authResult, error in
            if error == nil {
                temp = 1
                alert(title: "Successfully", message: "Successfully Login")
            }
            else {
                temp = 0
                alert(title: "Error!", message: "Login Error!")
            }
        }
    }
    
    // Sign Up Button Action
    @IBAction func signUpButtonAction(_ sender: Any) {
        let signUpNaviaget = storyboard?.instantiateViewController(identifier: "SignUpViewController") as! SignUpViewController
        
        navigationController?.popViewController(animated: true)
    }
    
    // Forgot Password Button Action
    @IBAction func forgotPasswordButAction(_ sender: Any) {
        let forgotNaviaget = storyboard?.instantiateViewController(identifier: "ConfromEmailPage") as! ConfromEmailPage
        
        navigationController?.pushViewController(forgotNaviaget, animated: true)
    }
    
    @IBAction func googleLoginButtonAction(_ sender: Any) {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { [unowned self] result, error in
            if error != nil {
                temp = 1
                alert(title: "Error!", message: "")
            }
            else {
                let user = result?.user
                let idToken = user?.idToken?.tokenString
                
                let credential = GoogleAuthProvider.credential(withIDToken: idToken ?? "",
                                                               accessToken: user?.accessToken.tokenString ?? "")
                
                Auth.auth().signIn(with: credential) { [self] result, error in
                    if error == nil {
                        temp = 1
                        alert(title: "Successfully!", message: "Sign Up successfully")
                    }
                    else {
                        temp = 0
                        alert(title: "Error!", message: error?.localizedDescription ?? "nil")
                    }
                }
            }
        }
    }
}

//MARK: Alert Func.
extension LoginViewController {
    
    func alert(title: String, message: String) {
        if temp == 0 {
            let a = UIAlertController(title: title, message: message, preferredStyle: .alert)
            
            a.addAction(UIAlertAction(title: "Ok", style: .cancel))
            a.addAction(UIAlertAction(title: "Cansel", style: .destructive))
            
            present(a, animated: true, completion: {
                a.view.superview?.isUserInteractionEnabled = true
                a.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.dismissOnTapOutside)))
            })
        }
        else {
            let a = UIAlertController(title: title, message: message, preferredStyle: .alert)
            
            a.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { [self] alert in
                let naviagte = storyboard?.instantiateViewController(identifier: "TabBarViewController") as! TabBarViewController
                navigationController?.pushViewController(naviagte, animated: true)
            }))
            a.addAction(UIAlertAction(title: "Cansel", style: .destructive))
            
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

extension LoginViewController {
    func design() {
        googleButnOutlet.layer.cornerRadius = 10
        
        let textFieldArray = [emailLableOutlet,passwordLableOutlet]
        
        for i in textFieldArray {
            i?.layer.borderWidth = 1
            i?.layer.cornerRadius = 5
            i?.layer.borderColor = UIColor.systemMint.cgColor
        }
    }
}
