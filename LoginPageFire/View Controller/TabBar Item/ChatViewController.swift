//
//  ChatViewController.swift
//  LoginPageFire
//
//  Created by R95 on 23/04/24.
//

import UIKit
import FirebaseFirestoreInternal

struct ChatThread {
    var UID: [String]
    var threadUid: String
    var userName: String
}

class ChatViewController: UIViewController {
    
    @IBOutlet weak var userTableView: UITableView!
    
    let db = Firestore.firestore()
    var userArray = [ChatThread]()
    var temp = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        getData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func getData() {
        db.collection("DidSelectUser").addSnapshotListener{ [self] snapshot, error  in
            if error == nil{
                if let snapshot = snapshot{
                    userArray = snapshot.documents.map{ i in
                        return ChatThread(UID: i["User"] as? [String] ?? ["nil"], threadUid: i["ThreadUID"] as? String ?? "",userName: i["UserName"] as? String ?? "")
                    }
                    print(userArray)
                    userTableView.reloadData()
                }
            }
        }
    }
}

extension ChatViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = userTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ChatPageTableViewCell
        cell.userNameLableOutlet.text = userArray[indexPath.row].userName
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 122
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let select = storyboard?.instantiateViewController(identifier: "ChattingPageViewController") as! ChattingPageViewController
        select.namelabel = userArray[indexPath.row].userName
        select.threadID = userArray[indexPath.row].threadUid
        navigationController?.pushViewController(select, animated: true)
    }
    
}
