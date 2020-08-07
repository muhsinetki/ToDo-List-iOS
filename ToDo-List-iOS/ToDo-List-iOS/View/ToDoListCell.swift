//
//  ToDoListCell.swift
//  ToDo-List-iOS
//
//  Created by Muhsin Etki on 7.08.2020.
//  Copyright © 2020 Muhsin Etki. All rights reserved.
//

import Foundation
import UIKit

class TodoListCell: UITableViewCell {
    @IBOutlet weak var todoListCellView: UIView!
    @IBOutlet weak var cellNameLabel: UILabel!
    @IBOutlet weak var cellTypeLabel: UILabel!
    @IBOutlet weak var cellDeadlineLabel: UILabel!
    @IBOutlet weak var cellScoreLabel: UILabel!
    @IBOutlet weak var cellDeleteButton: UIButton!
    
    func setTask(_ cell: TodoListCell , name:String , type:String, deadline:Date, score:Int16 , index:Int) -> TodoListCell {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MMM-dd HH:mm"
        let deadlineStr = formatter.string(from: deadline)
        
        cell.cellNameLabel.text = name
        cell.cellTypeLabel.text = type
        cell.cellDeadlineLabel.text = deadlineStr
        cell.cellScoreLabel.text = "\(score)"
        cell.cellDeleteButton.setTitle("\(index)", for: .normal)
        cell.todoListCellView.layer.shadowColor = UIColor.black.cgColor
        cell.todoListCellView.layer.shadowOpacity = 0.2
        cell.todoListCellView.layer.shadowOffset = .zero
        cell.todoListCellView.layer.shadowRadius = 5
        return cell
    }
}
