//
//  ListViewController.swift
//  ToDo-List-iOS
//
//  Created by Muhsin Etki on 22.07.2020.
//  Copyright © 2020 Muhsin Etki. All rights reserved.
//

import UIKit

class ListViewController: UIViewController {
    
    var taskArray: [TaskModel] = []
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sortByPointButton: UIButton!
    @IBOutlet weak var sortByDeadlineButton: UIButton!
    
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
        taskArray=taskArray.sorted(by: { $0.deadline.compare($1.deadline) == .orderedAscending })
        tableView.reloadData()
    }
}

extension ListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath)
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.text = "Name:\(taskArray[indexPath.row].name)\nDeadline:\(taskArray[indexPath.row].deadline)\nPoint:\(taskArray[indexPath.row].point)"
        return cell
    }
}
