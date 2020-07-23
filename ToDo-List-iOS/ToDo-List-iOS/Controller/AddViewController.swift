//
//  ViewController.swift
//  ToDo-List-iOS
//
//  Created by Muhsin Etki on 21.07.2020.
//  Copyright © 2020 Muhsin Etki. All rights reserved.
//

import UIKit

class AddViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var typeTextField: UITextField!
    @IBOutlet weak var deadlineTextField: UITextField!
    @IBOutlet weak var pointTextField: UITextField!
    @IBOutlet weak var addTaskButton: UIButton!
    @IBOutlet weak var listTasksButton: UIButton!
    var taskArray: [TaskModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
     @IBAction func addTaskButtonPressed(_ sender: UIButton) {
        if let date = deadlineTextField.text , let name = nameTextField.text , let type = typeTextField.text, let point = pointTextField.text {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            if let deadline = dateFormatter.date(from: date){
                taskArray.append(TaskModel(name:  name , type: type, deadline: deadline, point: Int(point) ?? 0))
                warningLabel.text = "Task has been successfully added."
            }else {
                warningLabel.text = "Warning! Task failed to add to list"
            }
        }else {
            warningLabel.text = "Warning! Task failed to add to list"
        }
        nameTextField.text = ""
        typeTextField.text = ""
        deadlineTextField.text = ""
        pointTextField.text = ""
    }
    
    @IBAction func listTasksButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "goToList", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToList" {
            if let destinationVC = segue.destination as? ListViewController {
                destinationVC.taskArray = self.taskArray
            }
        }
    }
}

