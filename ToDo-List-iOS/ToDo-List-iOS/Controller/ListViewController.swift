//
//  ListViewController.swift
//  ToDo-List-iOS
//
//  Created by Muhsin Etki on 22.07.2020.
//  Copyright © 2020 Muhsin Etki. All rights reserved.
//

import UIKit
import CoreData

class TodoListCell: UITableViewCell {
    @IBOutlet weak var cellNameLabel: UILabel!
    @IBOutlet weak var cellTypeLabel: UILabel!
    @IBOutlet weak var cellDeadlineLabel: UILabel!
    @IBOutlet weak var cellScoreLabel: UILabel!
    @IBOutlet weak var cellDeleteButton: UIButton!
}

class ListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sortByScoreButton: UIButton!
    @IBOutlet weak var sortByDeadlineButton: UIButton!
    var taskArray =  [TaskItem]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.layer.borderColor = #colorLiteral(red: 0.3807474971, green: 0.7858162522, blue: 0.8063432574, alpha: 1)
        title = "ToDo List"
        loadTaskItems()
        tableView.dataSource = self
    }
    
    @IBAction func cellDeleteButtonPressed(_ sender: UIButton) {
        let index = Int(sender.currentTitle!)!
        self.context.delete(self.taskArray[index])
        self.taskArray.remove(at: index)
        self.saveTaskItems()
        self.tableView.reloadData()
    }
    
    @IBAction func sortByScoreButtonPressed(_ sender: UIButton) {
        taskArray=taskArray.sorted(by: { $0.point > $1.point })
        tableView.reloadData()
    }
    
    @IBAction func sortByDeadlineButtonPressed(_ sender: UIButton) {
        taskArray=taskArray.sorted(by: { $0.deadline!.compare($1.deadline!) == .orderedAscending })
        tableView.reloadData()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath) as! TodoListCell
        let taskItem = taskArray[indexPath.row]
        if let name = taskItem.name , let type = taskItem.type , let dead = taskItem.deadline {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MMM-dd HH:mm"
            let deadline = formatter.string(from: dead)

            cell.cellNameLabel.text = name
            cell.cellTypeLabel.text = type
            cell.cellDeadlineLabel.text = deadline
            cell.cellScoreLabel.text = "\(taskItem.point)"
            cell.cellDeleteButton.setTitle("\(indexPath.row)", for: .normal)
        }
        return cell
    }
}
