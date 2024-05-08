//
//  ChatViewController.swift
//  LoginPageFire
//
//  Created by R95 on 23/04/24.
//

import UIKit
import FirebaseFirestoreInternal

struct ChatTread {
    var UID: uid
    var threadUid: String
}

struct uid {
    var name: String
    var userUID: String
}

class ChatViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var userTableView: UITableView!
    
    let db = Firestore.firestore()
    var userArray = [ChatTread]()
    var removeData = ""
    var temp = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        getData()
    }
    
    func getData() {
        Task { @MainActor in
            db.collection("Thread").addSnapshotListener { [self] snapshot, error in
                if let error = error {
                    print("Error fetching documents: \(error)")
                    return
                }
                
                if let snapshot = snapshot {
                    var namesSet = Set<String>() // Create a set to store unique names
                    
                    userArray = snapshot.documents.compactMap { document in
                        guard let user = document["User"] as? [String],
                              let userUID = user.first, // Assuming you want the last element of the array
                              let name = user.last, // Assuming you want the first element of the array
                              let threadUID = document["ThreadUID"] as? String
                        else {
                            return nil
                        }
                        
                        if namesSet.contains(name) {
                            // Name already exists, do something if needed
                            // For now, let's print a message
                            print("\(name) is repeated")
                        } else {
                            // Name is unique, add it to the set and return ChatTread
                            namesSet.insert(name)
                            return ChatTread(UID: uid(name: name, userUID: userUID), threadUid: threadUID)
                        }
                        return nil // Return nil for duplicate names
                    }
                }
                print(userArray)
                userTableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = userTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ChatPageTableViewCell
        
        DispatchQueue.main.async { [self] in
            let userString = userArray[indexPath.row].UID.name
            cell.userNameLableOutlet.text = userString
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 94
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let select = storyboard?.instantiateViewController(identifier: "ChattingPageViewController") as! ChattingPageViewController
        select.namelabel = userArray[indexPath.row].UID.name // or userArray[indexPath.row].uid.description to show the array
        select.threadID = userArray[indexPath.row].threadUid
        navigationController?.pushViewController(select, animated: true)
    }
    
//    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
//        return .delete
//    }
    
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            tableView.beginUpdates()
//            let removedChatTread = userArray.remove(at: indexPath.row)
//            removeData = removedChatTread.threadUid // Assign the threadUid to removeData
//            tableView.deleteRows(at: [indexPath], with: .fade)
//            tableView.endUpdates()
//        }
//    }
}
