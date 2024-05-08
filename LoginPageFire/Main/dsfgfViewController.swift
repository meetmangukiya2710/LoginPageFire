//
//  dsfgfViewController.swift
//  LoginPageFire
//
//  Created by R95 on 30/04/24.
//

import UIKit

class dsfgfViewController: UIViewController {
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(KeyboardApear), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(KeyboardDisapear), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    @IBAction func buttonAction(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    var isExpand: Bool = true
    @objc func KeyboardApear() {
        if !isExpand {
            self.scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.scrollView.frame.height + 200)
            isExpand = true
        }
    }
    
    @objc func KeyboardDisapear() {
        if isExpand {
            self.scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.scrollView.frame.height - 200)
            isExpand = false
        }
        
    }
}
