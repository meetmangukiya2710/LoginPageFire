//
//  ViewController.swift
//  LoginPageFire
//
//  Created by R95 on 16/04/24.
//

import UIKit
import FirebaseAuth

class ViewController: UIViewController {
    
    @IBOutlet weak var continueButOutlet: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        design()
        navigationItem.hidesBackButton = true
    }
    
    //MARK: Continue Button.
    @IBAction func continueButtonAction(_ sender: Any) {
        let naviage = storyboard?.instantiateViewController(withIdentifier: "MainLoginPage") as! MainLoginPage
        navigationController?.pushViewController(naviage, animated: true)
    }
    
    func design() {
        continueButOutlet.layer.cornerRadius = 10
    }
    
}
