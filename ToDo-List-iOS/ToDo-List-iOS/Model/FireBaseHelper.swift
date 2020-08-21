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
    var taskArray =  [TaskItem]()
    
    private init() {
        self.db = Firestore.firestore()
        Auth.auth().signInAnonymously { (result, error) in
            guard let user = result?.user else { return }
            self.userName = user.uid
        }
    }
    func addTask(name:String,type:String,deadline:Date, score:Int16, completionHandler: @escaping (Result<String ,Error>) -> Void) {
        let newTaskItem = TaskItem(context: context)
        newTaskItem.deadline = deadline
        newTaskItem.name = name
        newTaskItem.point = score
        newTaskItem.type = type
        var ref: DocumentReference? = nil
        ref = self.db.collection(FireBaseHelper.shared.userName!).addDocument(data: [
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
                self.saveTaskItemsForCoreData { (result) in
                    switch result {
                    case .success(_):
                        return
                    case .failure(let error):
                        completionHandler(.failure(error))
                    }
                }
            }
        }
    }
    
    func sync(completionHandler: @escaping (Result<String ,Error>) -> Void)  {
        var coreArray = [TaskItem]()
        let request: NSFetchRequest<TaskItem> = TaskItem.fetchRequest()
        do {
            coreArray = try context.fetch(request)
        } catch  let err{
            completionHandler(.failure(err))
        }
        if let userName = FireBaseHelper.shared.userName {
            self.db.collection(userName).getDocuments() { (querySnapshot, err) in
                if let err = err {
                    completionHandler(.failure(err))
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
                                            self.saveTaskItemsForCoreData { (result) in
                                                switch result {
                                                case .success(_):
                                                    return
                                                case .failure(let error):
                                                    completionHandler(.failure(error))
                                                }
                                            }
                                        }
                                    }
                                }else {
                                    self.saveTaskItemsForCoreData { (result) in
                                        switch result {
                                        case .success(_):
                                            return
                                        case .failure(let error):
                                            completionHandler(.failure(error))
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    func saveTaskItemsForCoreData(completionHandler: @escaping (Result<String ,Error>) -> Void) {
        do {
            try context.save()
        } catch  let err{
            completionHandler(.failure(err))
        }
    }
    
    func deleteTask(index:Int , completionHandler: @escaping (Result<String ,Error>) -> Void)  {
        self.context.delete(self.taskArray[index])
        if let id = self.taskArray[index].id{
            self.db.collection(FireBaseHelper.shared.userName!).document( id).delete() { err in
                if let err = err {
                    completionHandler(.failure(err))
                }
            }
        }
        self.taskArray.remove(at: index)
        self.saveTaskItemsForCoreData { (result) in
            switch result {
            case .success(_):
                return
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    func loadTaskItemsWithCoreData(completionHandler: @escaping (Result<[TaskItem] ,Error>) -> Void){
        let request: NSFetchRequest<TaskItem> = TaskItem.fetchRequest()
        do {
            taskArray = try context.fetch(request)
            completionHandler(.success(taskArray))
        } catch  let err{
            completionHandler(.failure(err))
        }
    }
}
