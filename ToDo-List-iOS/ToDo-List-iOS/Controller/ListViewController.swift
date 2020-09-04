//
//  ListViewController.swift
//  ToDo-List-iOS
//
//  Created by Muhsin Etki on 22.07.2020.
//  Copyright © 2020 Muhsin Etki. All rights reserved.
//

import UIKit

class ListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sortByScoreButton: UIButton!
    @IBOutlet weak var sortByDeadlineButton: UIButton!
    var taskArray =  [TaskItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.layer.borderColor = #colorLiteral(red: 0.3807474971, green: 0.7858162522, blue: 0.8063432574, alpha: 1)
        self.tableView.contentInset = UIEdgeInsets(top: 30, left: 0, bottom: 0, right: 0)
        title = "ToDo List"
        FireBaseHelper.shared.loadTaskItemsWithCoreData(completionHandler: { (result) in
            switch result {
            case .success(let data):
                self.taskArray = data
            case .failure(let error):
                self.alert(error: error)
            }
        })
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
    
    func alert(error:Error)  {
        let alertController = UIAlertController(title: title, message: error.localizedDescription, preferredStyle:UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
        { action -> Void in
        })
        self.present(alertController, animated: true, completion: nil)
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
            DispatchQueue.main.async {
                FireBaseHelper.shared.deleteTask(index: index , array: self.taskArray) { (result) in
                    switch result {
                    case .success(let data):
                        self.taskArray = data
                        self.tableView.reloadData()
                        return
                    case .failure(let error):
                        self.alert(error: error)
                    }
                }
            }
        }
    }
}
