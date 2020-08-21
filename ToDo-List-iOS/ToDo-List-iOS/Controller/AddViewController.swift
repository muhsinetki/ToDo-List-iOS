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
    @IBOutlet weak var taskView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FireBaseHelper.shared.sync { (result) in
            switch result {
            case .success(_):
                return
            case .failure(let error):
                self.alert(error: error)
            }
        }
        taskView.layer.borderColor = #colorLiteral(red: 0.3807474971, green: 0.7858162522, blue: 0.8063432574, alpha: 1)
        nameTextField.layer.shadowColor = UIColor.black.cgColor
        typeTextField.layer.shadowColor = UIColor.black.cgColor
        deadlineTextField.layer.shadowColor = UIColor.black.cgColor
        pointTextField.layer.shadowColor = UIColor.black.cgColor
    }
    enum MyError: Error {
        case runtimeError(String)
    }
    
    @IBAction func addTaskButtonPressed(_ sender: UIButton) {
        let date = deadlineTextField.text ?? ""
        let name = nameTextField.text ?? ""
        let type = typeTextField.text ?? ""
        let point = pointTextField.text ?? ""
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        let errorMessage = "There was an error adding the task to the list."
        if let deadline = dateFormatter.date(from: date) {
            if name != "" && type != "" && point != ""{
                FireBaseHelper.shared.addTask(name: name, type: type, deadline: deadline, score: Int16(point) ?? 0) { (result) in
                    switch result {
                    case .success(_):
                        return
                    case .failure(let error):
                        self.alert(error: error)
                    }
                }
            }else {
                alert(error: MyError.runtimeError(errorMessage))
            }
        }else {
            alert(error: MyError.runtimeError(errorMessage))
        }
    }
    
    @IBAction func listTasksButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "goToList", sender: self)
    }
    
    func alert(error:Error)  {
        let alertController = UIAlertController(title: title, message: error.localizedDescription, preferredStyle:UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
        { action -> Void in
        })
        self.present(alertController, animated: true, completion: nil)
    }
}
