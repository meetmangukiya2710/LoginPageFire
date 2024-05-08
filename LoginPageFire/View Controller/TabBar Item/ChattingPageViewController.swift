//
//  ChattingPageViewController.swift
//  LoginPageFire
//
//  Created by R95 on 23/04/24.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import FirebaseFirestoreInternal

struct ChatData {
    var message: String
    var sender: String
    var time: Date
    var dataType: String
    var imagePath: String
    
    init(dic: QueryDocumentSnapshot) {
        self.message = dic["Message"] as? String ?? "nil mesg"
        self.sender = dic["Sender"] as? String ?? "nil sender"
        self.time = (dic["Time"] as! Timestamp).dateValue()
        self.dataType = dic["dataTpye"] as? String ?? "nil datatype"
        self.imagePath = dic["imagePath"] as? String ?? "nil imagePath"
    }
}

class ChattingPageViewController: UIViewController {
    
    @IBOutlet weak var chatTableViewOutlet: UITableView!
    @IBOutlet weak var nameLableOutlet: UILabel!
    @IBOutlet weak var chatTextFieldOutlet: UITextField!
    
    var namelabel = ""
    var threadID = ""
    var db = Firestore.firestore()
    var userArray = [ChatData]()
    var uid = Auth.auth().currentUser?.uid
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLableOutlet.text = namelabel
        getData()
        navigationItem.hidesBackButton = true
    }
    
    @IBAction func sendButtonAction(_ sender: Any) {
        let dic = ["Message": chatTextFieldOutlet.text as Any,
                   "Time": Date(),
                   "Sender": uid as Any,
                   "dataTpye": "Message",
                   "imagePath": ""]
        
        db.collection("Thread").document(threadID).collection("Chat").addDocument(data: dic) { [self] error in
            if error == nil {
                chatTextFieldOutlet.text = ""
            }
        }
    }
    
    func getData() {
        db.collection("Thread").document(threadID).collection("Chat").order(by: "Time", descending: false).addSnapshotListener { [self] snapShot, error in
            if let snapshot = snapShot {
                userArray = snapshot.documents.map { i in ChatData(dic: i) }
                print(userArray)
                chatTableViewOutlet.reloadData()
            }
        }
    }
    
    //MARK: Keyboard Code
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
}

extension ChattingPageViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = chatTableViewOutlet.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! UserChatPageTableViewCell
        
        let message = userArray[indexPath.row].message
            cell.messageLableOutlet.text = message

        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
}
