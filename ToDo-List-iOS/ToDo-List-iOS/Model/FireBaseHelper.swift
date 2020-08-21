//
//  FireBaseHelper.swift
//  ToDo-List-iOS
//
//  Created by Muhsin Etki on 21.08.2020.
//  Copyright © 2020 Muhsin Etki. All rights reserved.
//
import FirebaseFirestore
import FirebaseAuth
import CoreData

class FireBaseHelper {
    
    let db: Firestore
    var userName:String?
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    static let shared = FireBaseHelper()
    
    private init() {
        self.db = Firestore.firestore()
        Auth.auth().signInAnonymously { (result, error) in
            self.userName = result?.user.uid
        }
    }
    func addTasks(name:String,type:String,deadline:Date, score:Int16) {
        let newTaskItem = TaskItem(context: context)
        newTaskItem.deadline = deadline
        newTaskItem.name = name
        newTaskItem.point = score
        newTaskItem.type = type
        var ref: DocumentReference? = nil
        if let userName = FireBaseHelper.shared.userName {
            ref = self.db.collection(userName).addDocument(data: [
                "name": name,
                "type": type,
                "deadline": deadline as Date,
                "score": score
            ]) { err in
                if let err = err {
                    print(err)
                } else {
                    print("Document added with ID: \(ref!.documentID)")
                    newTaskItem.id=ref!.documentID
                    self.saveTaskItemsForCoreData()
                }
            }
        }
    }
    
    func sync()  {
        var coreArray = [TaskItem]()
        let request: NSFetchRequest<TaskItem> = TaskItem.fetchRequest()
        do {
            coreArray = try context.fetch(request)
        } catch  {
            print("Error fetching data from context \(error)")
        }
        if let userName = FireBaseHelper.shared.userName {
            self.db.collection(userName).getDocuments() { (querySnapshot, err) in
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
                                if coreArray.count != 0 {
                                    for i in coreArray{
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
    func saveTaskItemsForCoreData() {
        do {
            try context.save()
        } catch  {
            print("Error decoding item array, \(error)")
        }
    }
}
