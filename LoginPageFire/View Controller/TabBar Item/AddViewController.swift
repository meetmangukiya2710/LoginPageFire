//
//  AddViewController.swift
//  LoginPageFire
//
//  Created by R95 on 23/04/24.
//

import UIKit
import FirebaseFirestoreInternal
import FirebaseAuth

struct UserData {
    var currentUserUID: String
    var selectUserName: String
    var selectUserUID: String
}

class AddViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
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
        Task { @MainActor in
            
            let snapshot = try await db.collection("User").getDocuments()
            for document in snapshot.documents {
                if let firstName = document.data()["First Name"] as? String,
                   let lastName = document.data()["Last Name"] as? String {
                    let fullName = "\(firstName) \(lastName)"
                    
                    if userUID == document.documentID {
                        print("Not Append")
                    }
                    else {
                        let userData = UserData(currentUserUID: userUID, selectUserName: fullName, selectUserUID: document.documentID)
                        userArray.append(userData)
                        userTableView.reloadData()
                    }
                } else {
                    print("Error: Could not retrieve first name and/or last name from document data.")
                }
            }
        }
    }
}

extension AddViewController {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = userTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! UserNameTableViewCell
        DispatchQueue.main.async { [self] in
            cell.userNameLableOutlet.text = userArray[indexPath.row].selectUserName
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 94
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let a = db.collection("Thread").document()
        let dic = [
            "User": [userArray[indexPath.row].selectUserUID, userUID, userArray[indexPath.row].selectUserName], // Assuming uid is accessible here
            "ThreadUID": a.documentID
        ] as [String : Any]
        a.setData(dic)
        tabBarController?.selectedIndex = 0
    }
}
