//
//  ListViewController.swift
//  ToDo-List-iOS
//
//  Created by Muhsin Etki on 22.07.2020.
//  Copyright © 2020 Muhsin Etki. All rights reserved.
//

import UIKit
import CoreData
import FirebaseFirestore

class ListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sortByScoreButton: UIButton!
    @IBOutlet weak var sortByDeadlineButton: UIButton!
    let db = Firestore.firestore()
    var taskArray =  [TaskItem]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.layer.borderColor = #colorLiteral(red: 0.3807474971, green: 0.7858162522, blue: 0.8063432574, alpha: 1)
        self.tableView.contentInset = UIEdgeInsets(top: 30, left: 0, bottom: 0, right: 0)
        title = "ToDo List"
        loadTaskItemsWithCoreData()
        tableView.dataSource = self
    }
    
    @IBAction func sortByScoreButtonPressed(_ sender: UIButton) {
        taskArray=taskArray.sorted(by: { $0.point > $1.point })
        tableView.reloadData()
    }
    
    @IBAction func sortByDeadlineButtonPressed(_ sender: UIButton) {
        taskArray=taskArray.sorted(by: { $0.deadline!.compare($1.deadline!) == .orderedAscending })
        tableView.reloadData()
    }
    
    func saveTaskItemsForCoreData() {
        do {
            try context.save()
        } catch  {
            print("Error decoding item array, \(error)")
        }
    }
    
    func loadTaskItemsWithCoreData()  {
        let request: NSFetchRequest<TaskItem> = TaskItem.fetchRequest()
        do {
            taskArray = try context.fetch(request)
        } catch  {
            print("Error fetching data from context \(error)")
        }
    }
}
//MARK: - UITableViewDataSource
extension ListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath) as! TodoListCell
        let taskItem = taskArray[indexPath.row]
        if let name = taskItem.name , let type = taskItem.type , let dead = taskItem.deadline {
            cell = cell.setTask(task: taskItem,name: name, type: type, deadline: dead, score: taskItem.point, index: indexPath.row)
            cell.delegate=self
        }
        return cell
    }
}

//MARK: - TodoListCellDelegate
extension ListViewController: ToDoListCellDelegate {
    func todoListCellDidDeleteButtonPressed(cell: TodoListCell) {
        if let index = self.taskArray.firstIndex(where: {$0 == cell.task}){
            self.context.delete(self.taskArray[index])
            if let id = self.taskArray[index].id{
                db.collection("tasks").document( id).delete() { err in
                    if let err = err {
                        print("Error removing document: \(err)")
                    }
                }
            }
            self.taskArray.remove(at: index)
            self.saveTaskItemsForCoreData()
            tableView.reloadData()
        }
    }
}
