//
//  ViewController.swift
//  ToDo-List-iOS
//
//  Created by Muhsin Etki on 21.07.2020.
//  Copyright © 2020 Muhsin Etki. All rights reserved.
//

import UIKit
import CoreData

class AddViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var typeTextField: UITextField!
    @IBOutlet weak var deadlineTextField: UITextField!
    @IBOutlet weak var pointTextField: UITextField!
    @IBOutlet weak var addTaskButton: UIButton!
    @IBOutlet weak var listTasksButton: UIButton!
    
    var taskArray = [Item]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadItems()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func addTaskButtonPressed(_ sender: UIButton) {
        let date = deadlineTextField.text ?? ""
        let name = nameTextField.text ?? ""
        let type = typeTextField.text ?? ""
        let point = pointTextField.text ?? ""
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let alertController = UIAlertController(title: title, message: "There was an error adding the task to the list.", preferredStyle:UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
        { action -> Void in
        })
        
        if let deadline = dateFormatter.date(from: date) {
            if name != "" && type != "" && point != ""{
                
                let newItem = Item(context: context)
                newItem.deadline = deadline
                newItem.name = name
                newItem.point = Int16(point) ?? 0
                newItem.type = type
                
                self.taskArray.append(newItem)
                self.saveItems()
                
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToList" {
            if let destinationVC = segue.destination as? ListViewController {
                loadItems()
                destinationVC.taskArray = self.taskArray
            }
        }
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
