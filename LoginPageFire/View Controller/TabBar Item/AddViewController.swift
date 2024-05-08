//
//  AddViewController.swift
//  LoginPageFire
//
//  Created by R95 on 23/04/24.
//

import UIKit
import FirebaseFirestoreInternal
import FirebaseFirestore
import FirebaseAuth

struct UserData {
    var UID: String
    var firstName: String
    var lastName: String
}

class AddViewController: UIViewController {
    
    @IBOutlet weak var userTableView: UITableView!
    
    let db = Firestore.firestore()
    var userArray: [UserData] = []
    var temp = 0
    var uid: String = ""
    var userUID = Auth.auth().currentUser?.uid ?? ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
        navigationItem.hidesBackButton = true
    }
    
    func getData() {
        db.collection("User").getDocuments{[self] snapshot,error in
            if error == nil {
                if let snapshot = snapshot {
                    userArray = snapshot.documents.map{ i in
                        return UserData(UID: i["uid"] as! String,firstName: i["First Name"] as! String ,lastName: i["Last Name"] as! String)
                    }
                    print(userArray)
                    userTableView.reloadData()
                }
            } else {
                print(error?.localizedDescription as Any)
            }
        }
    }
}

extension AddViewController:  UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = userTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! UserNameTableViewCell
        DispatchQueue.main.async { [self] in
            cell.userNameLableOutlet.text = userArray[indexPath.row].firstName + " " + userArray[indexPath.row].lastName
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 94
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let a = db.collection("DidSelectUser").document()
        let dic = [
            "User": [userArray[indexPath.row].UID, userUID],
            "ThreadUID": a.documentID,
            "UserName" : userArray[indexPath.row].firstName + " " + userArray[indexPath.row].lastName] as [String : Any]
        a.setData(dic)
        tabBarController?.selectedIndex = 0
    }
}

