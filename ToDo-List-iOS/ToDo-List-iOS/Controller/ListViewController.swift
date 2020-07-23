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
    
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sortByPointButton: UIButton!
    @IBOutlet weak var sortByDeadlineButton: UIButton!
    
    var taskArray =  [Item]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "ToDo List"
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
    
    @IBAction func deleteButtonPressed(_ sender: UIButton) {
        //1. Create the alert controller for error.
        let alertController = UIAlertController(title: "Warning!", message: "There was an error deleting the task from the list.", preferredStyle:UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
        { action -> Void in
        })
        //1. Create the alert controller for deleting.
        let alert = UIAlertController(title: "Delete a Task", message: "Enter the task number", preferredStyle: .alert)
        //2. Add the text field. You can configure it however you need.
        alert.addTextField { (textField) in
            textField.text = ""
            textField.placeholder = "e.g. 1 or 2 or 3"
        }
        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "Delete!", style: .default, handler: { [weak alert] (_) in
            if let textField = alert?.textFields?[0] {
                if let indexString = textField.text{
                    if let index2 = Int(indexString) {
                        let index = index2 - 1
                        if 0..<self.taskArray.count ~= index {
                            self.context.delete(self.taskArray[index])
                            self.taskArray.remove(at: index)
                            self.saveItems()
                            self.tableView.reloadData()
                        }else {
                            self.present(alertController, animated: true, completion: nil)
                        }
                    }else{
                        self.present(alertController, animated: true, completion: nil)
                    }
                }else {
                    self.present(alertController, animated: true, completion: nil)
                }
                
            }else{
                self.present(alertController, animated: true, completion: nil)
            }
        }))
        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
    }
    func saveItems() {
        do {
            try context.save()
        } catch  {
            print("Error decoding item array, \(error)")
        }
    }
    
    func loadItems()  {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
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
        let item = taskArray[indexPath.row]
        cell.textLabel?.text = "\(indexPath.row+1). Name:\(item.name!)\nDeadline:\(item.deadline!)\nPoint:\(item.point)"
        return cell
    }
}

