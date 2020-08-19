//
//  ViewController.swift
//  ToDo-List-iOS
//
//  Created by Muhsin Etki on 21.07.2020.
//  Copyright © 2020 Muhsin Etki. All rights reserved.
//

import UIKit
import CoreData
import FirebaseFirestore
import FirebaseAuth


class AddViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var typeTextField: UITextField!
    @IBOutlet weak var deadlineTextField: UITextField!
    @IBOutlet weak var pointTextField: UITextField!
    @IBOutlet weak var addTaskButton: UIButton!
    @IBOutlet weak var listTasksButton: UIButton!
    @IBOutlet weak var taskView: UIView!
    var taskArray = [TaskItem]()
    let db = Firestore.firestore()
    var coreArray = [TaskItem]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("merhaba")
        sync()
        taskView.layer.borderColor = #colorLiteral(red: 0.3807474971, green: 0.7858162522, blue: 0.8063432574, alpha: 1)
        nameTextField.layer.shadowColor = UIColor.black.cgColor
        typeTextField.layer.shadowColor = UIColor.black.cgColor
        deadlineTextField.layer.shadowColor = UIColor.black.cgColor
        pointTextField.layer.shadowColor = UIColor.black.cgColor
    }
    
    @IBAction func addTaskButtonPressed(_ sender: UIButton) {
        let date = deadlineTextField.text ?? ""
        let name = nameTextField.text ?? ""
        let type = typeTextField.text ?? ""
        let point = pointTextField.text ?? ""
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        let alertController = UIAlertController(title: title, message: "There was an error adding the task to the list.", preferredStyle:UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
        { action -> Void in
        })
        if let deadline = dateFormatter.date(from: date) {
            if name != "" && type != "" && point != ""{
                let newTaskItem = TaskItem(context: context)
                newTaskItem.deadline = deadline
                newTaskItem.name = name
                newTaskItem.point = Int16(point) ?? 0
                newTaskItem.type = type
                //firestore below
                var ref: DocumentReference? = nil
                Auth.auth().signInAnonymously() { (authResult, error) in
                    guard let user = authResult?.user else { return }
                    ref = self.db.collection(user.uid).addDocument(data: [
                        "name": name,
                        "type": type,
                        "deadline": deadline as Date,
                        "score": Int16(point) ?? 0
                    ]) { err in
                        if let err = err {
                            print("Error adding document: \(err)")
                        } else {
                            print("Document added with ID: \(ref!.documentID)")
                            newTaskItem.id = ref!.documentID
                            self.saveTaskItemsForCoreData()
                        }
                    }
                }
                //Firestore above
            }else {
                self.present(alertController, animated: true, completion: nil)
            }
        }else {
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    @IBAction func listTasksButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "goToList", sender: self)
    }
    
    func saveTaskItemsForCoreData() {
        do {
            try context.save()
        } catch  {
            print("Error decoding item array, \(error)")
        }
    }
    
    func sync()  {
        self.coreArray=[]
        let request: NSFetchRequest<TaskItem> = TaskItem.fetchRequest()
        do {
            coreArray = try context.fetch(request)
        } catch  {
            print("Error fetching data from context \(error)")
        }
        Auth.auth().signInAnonymously() { (authResult, error) in
            guard let user = authResult?.user else { return }
            self.db.collection(user.uid).getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    if let snapshotDocuments = querySnapshot?.documents{
                        for document in snapshotDocuments {
                            if let deadline = document.data()["deadline"] as? Timestamp, let name = document.data()["name"] as? String, let score = document.data()["score"] as? Int16, let type = document.data()["type"] as? String {
                                let newTaskItem = TaskItem(context: self.context)
                                newTaskItem.deadline = deadline.dateValue()
                                newTaskItem.name = name
                                newTaskItem.point = score
                                newTaskItem.type = type
                                newTaskItem.id = document.documentID
                                if self.coreArray.count != 0 {
                                    for i in self.coreArray{
                                        if i.name == name && i.type == type && i.deadline == deadline.dateValue() && i.point == score {
                                            return
                                        }else {
                                            self.saveTaskItemsForCoreData()
                                        }
                                    }
                                }else {
                                    self.saveTaskItemsForCoreData()
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
