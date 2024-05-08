//
//  SignUpViewController.swift
//  LoginPageFire
//
//  Created by R95 on 16/04/24.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import GoogleSignIn
import FirebaseFirestore

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var signUpButnOutlet: UIButton!
    @IBOutlet weak var googleButnOutlet: UIButton!
    @IBOutlet weak var fstNameLableOutlet: UITextField!
    @IBOutlet weak var lstNameLableOutlet: UITextField!
    @IBOutlet weak var emailLableOutlet: UITextField!
    @IBOutlet weak var phoneNumberLableOutlet: UITextField!
    @IBOutlet weak var passwordLableOutlet: UITextField!
    @IBOutlet weak var confirmPasswordLableOutlet: UITextField!
    
    var activityIndicator: UIActivityIndicatorView!
    var temp = 0
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        design()
        activityIndicatorFunc()
    }
    
    //MARK: Keyboard Code
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    //MARK: SignUp Button
    @IBAction func signUpButtonAction(_ sender: Any) {
        if passwordLableOutlet.text == confirmPasswordLableOutlet.text {
            Auth.auth().createUser(withEmail: emailLableOutlet.text ?? "", password: confirmPasswordLableOutlet.text ?? "") { [self] authResult, error in
                if error == nil {
                    temp = 0
                    let dec = ["First Name": fstNameLableOutlet.text ?? "","Last Name": lstNameLableOutlet.text ?? "","Email": emailLableOutlet.text ?? "","Password": confirmPasswordLableOutlet.text ?? "","Moblie Number": phoneNumberLableOutlet.text ?? ""]
                    
                    db.collection("User").document(Auth.auth().currentUser?.uid ?? "").setData(dec)
                    alert(title: "Successfully!", message: "Sign Up successfully")
                }
                else {
                    temp = 1
                    alert(title: "Error!", message: error?.localizedDescription ?? "nil")
                }
            }
        }
        else {
            temp = 1
            alert(title: "Error!", message: "Both eny one Password is Wrong!")
        }
    }
    
    @IBAction func loginButtonAction(_ sender: Any) {
        let loginNaviaget = storyboard?.instantiateViewController(identifier: "LoginViewController") as! LoginViewController
        navigationController?.pushViewController(loginNaviaget, animated: true)
    }
    
    //MARK: Google Sign Up Func.
    @IBAction func googleSignupButtonAction(_ sender: Any) {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { [unowned self] result, error in
            if error == nil {
                let user = result?.user
                let idToken = user?.idToken?.tokenString
                
                let credential = GoogleAuthProvider.credential(withIDToken: idToken ?? "",
                                                               accessToken: user?.accessToken.tokenString ?? "")
                
                Auth.auth().signIn(with: credential) { [self] result, error in
                    if error == nil {
                        temp = 0
                        alert(title: "Successfully!", message: "Sign Up successfully")
                    }
                    else {
                        temp = 1
                        alert(title: "Error!", message: error?.localizedDescription ?? "nil")
                    }
                }
            }
            else {
                temp = 1
                alert(title: "Error!", message: "")
            }
        }
    }
}

//MARK: - Alert Func.
extension SignUpViewController {
    func alert(title: String, message: String) {
        if temp == 0 {
            let a = UIAlertController(title: title, message: message, preferredStyle: .alert)
            
            a.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { [self] _ in
                let loginNaviaget = storyboard?.instantiateViewController(identifier: "LoginViewController") as! LoginViewController
                
                navigationController?.pushViewController(loginNaviaget, animated: true)
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

//MARK: Activity Indicator Func
extension SignUpViewController {
    func activityIndicatorFunc() {
        signUpButnOutlet.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        
        activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.color = UIColor.blue // Set your desired color
        activityIndicator.hidesWhenStopped = true
        signUpButnOutlet.addSubview(activityIndicator)
        activityIndicator.center = CGPoint(x: signUpButnOutlet.bounds.midX, y: signUpButnOutlet.bounds.midY)
    }
    
    @objc func didTapButton() {
        // Show the activity indicator
        activityIndicator.startAnimating()
        // Perform your button action here
        
        // Once your task is complete, stop the activity indicator
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [self] in
            self.activityIndicator.stopAnimating()
            
            if fstNameLableOutlet.text == "" && lstNameLableOutlet.text == "" && emailLableOutlet.text == "" && phoneNumberLableOutlet.text == "" && passwordLableOutlet.text == "" && confirmPasswordLableOutlet.text == "" {
                temp = 1
                alert(title: "Error!", message: "Enter the All Detail")
            }
            else if fstNameLableOutlet.text == "" {
                temp = 1
                alert(title: "Error!", message: "Enter the Fst Name")
            }
            else if lstNameLableOutlet.text == "" {
                temp = 1
                alert(title: "Error!", message: "Enter the Lst Name")
            }
            else if emailLableOutlet.text == "" {
                temp = 1
                alert(title: "Error!", message: "Enter the Email")
            }
            else if phoneNumberLableOutlet.text == "" {
                temp = 1
                alert(title: "Error!", message: "Enter the Phone Number")
            }
            else if passwordLableOutlet.text == "" {
                temp = 1
                alert(title: "Error!", message: "Enter the Password")
            }
            else if confirmPasswordLableOutlet.text == "" {
                temp = 1
                alert(title: "Error!", message: "Enter the Confrim Password")
            }
        }
    }
}

//MARK: Design Code
extension SignUpViewController {
    func design() {
        signUpButnOutlet.layer.cornerRadius = 10
        googleButnOutlet.layer.cornerRadius = 10
        
        let textFieldArray = [fstNameLableOutlet, lstNameLableOutlet, emailLableOutlet, phoneNumberLableOutlet, passwordLableOutlet, confirmPasswordLableOutlet]
        
        for i in textFieldArray {
            i?.layer.borderWidth = 1
            i?.layer.cornerRadius = 5
            i?.layer.borderColor = UIColor.systemMint.cgColor
        }
    }
}
