//
//  ToDoListCell.swift
//  ToDo-List-iOS
//
//  Created by Muhsin Etki on 7.08.2020.
//  Copyright © 2020 Muhsin Etki. All rights reserved.
//

import Foundation
import UIKit

protocol ToDoListCellDelegate {
    func  todoListCellDidDeleteButtonPressed(cell:TodoListCell)
}

class TodoListCell: UITableViewCell {
    var task: TaskItem?
    var delegate :ToDoListCellDelegate?
    @IBOutlet weak var todoListCellView: UIView!
    @IBOutlet weak var cellNameLabel: UILabel!
    @IBOutlet weak var cellTypeLabel: UILabel!
    @IBOutlet weak var cellDeadlineLabel: UILabel!
    @IBOutlet weak var cellScoreLabel: UILabel!
    @IBOutlet weak var cellDeleteButton: UIButton!
    
    func setTask(task :TaskItem, name:String , type:String, deadline:Date, score:Int16 , index:Int) -> TodoListCell {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MMM-dd HH:mm"
        let deadlineStr = formatter.string(from: deadline)
        self.task=task
        self.cellNameLabel.text = name
        self.cellTypeLabel.text = type
        self.cellDeadlineLabel.text = deadlineStr
        self.cellScoreLabel.text = "\(score)"
        self.cellDeleteButton.setTitle("\(index)", for: .normal)
        self.todoListCellView.layer.shadowColor = UIColor.black.cgColor
        self.todoListCellView.layer.shadowOpacity = 0.2
        self.todoListCellView.layer.shadowOffset = CGSize(width: 3, height: 3)
        self.todoListCellView.layer.shadowRadius = 3
        return self
    }

    @IBAction func cellDeleteButtonPressed(_ sender: UIButton) {
        self.delegate?.todoListCellDidDeleteButtonPressed(cell: self)
    }
}
