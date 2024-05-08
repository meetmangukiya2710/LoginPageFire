//
//  MainLoginPage.swift
//  LoginPageFire
//
//  Created by R95 on 16/04/24.
//

import UIKit
import TransitionButton

class MainLoginPage: UIViewController {
    
    @IBOutlet weak var signUpButnOutlet: UIButton!
    @IBOutlet weak var loginButnOutlet: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        design()
    }
    
    //MARK: SignUp Button.
    @IBAction func signUpButtonAction(_ sender: Any) {
        let signUpNaviagte = storyboard?.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
        
        navigationController?.pushViewController(signUpNaviagte, animated: true)
    }
    
    //MARK: Login Button.
    @IBAction func loginButtonAction(_ sender: Any) {
        let loginNaviagte = storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        
        navigationController?.pushViewController(loginNaviagte, animated: true)
    }
    
    func design() {
        signUpButnOutlet.layer.cornerRadius = 10
    }
}
