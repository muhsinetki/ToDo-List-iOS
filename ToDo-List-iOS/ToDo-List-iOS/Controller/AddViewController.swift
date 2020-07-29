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
    @IBOutlet weak var taskView: UIView!
    var taskArray = [TaskItem]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        taskView.layer.borderColor = #colorLiteral(red: 0.3807474971, green: 0.7858162522, blue: 0.8063432574, alpha: 1)
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
                
                self.taskArray.append(newTaskItem)
                self.saveTaskItems()
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

    func saveTaskItems() {
        do {
            try context.save()
        } catch  {
            print("Error decoding item array, \(error)")
        }
    }
}
