//
//  ListViewController.swift
//  ToDo-List-iOS
//
//  Created by Muhsin Etki on 22.07.2020.
//  Copyright © 2020 Muhsin Etki. All rights reserved.
//

import UIKit
import CoreData

class ListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sortByPointButton: UIButton!
    @IBOutlet weak var sortByDeadlineButton: UIButton!
    var taskArray =  [TaskItem]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "ToDo List"
        loadTaskItems()
        tableView.dataSource = self
    }
    
    @IBAction func sortByPointButtonPressed(_ sender: UIButton) {
        taskArray=taskArray.sorted(by: { $0.point > $1.point })
        tableView.reloadData()
    }
    
    @IBAction func sortByDeadlineButtonPressed(_ sender: UIButton) {
        taskArray=taskArray.sorted(by: { $0.deadline!.compare($1.deadline!) == .orderedAscending })
        tableView.reloadData()
    }
    
    func deleteTaskItem (taskItem: TaskItem){
        var index = 0
        for i in 0..<taskArray.count {
            if taskArray[i] == taskItem {
                index = i
                return
            }
        }
        self.context.delete(self.taskArray[index])
        self.taskArray.remove(at: index)
        self.saveTaskItems()
        self.tableView.reloadData()
    }
    
    func saveTaskItems() {
        do {
            try context.save()
        } catch  {
            print("Error decoding item array, \(error)")
        }
    }
    
    func loadTaskItems()  {
        let request: NSFetchRequest<TaskItem> = TaskItem.fetchRequest()
        do {
            taskArray = try context.fetch(request)
        } catch  {
            print("Error fetching data from context \(error)")
        }
    }
}

extension ListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath)
        cell.textLabel?.numberOfLines = 0
        let taskItem = taskArray[indexPath.row]
        cell.textLabel?.text = "\(indexPath.row+1). Name:\(taskItem.name!)\nDeadline:\(taskItem.deadline!)\nPoint:\(taskItem.point)"
        return cell
    }
}
